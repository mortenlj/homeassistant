
dep 'traefik' do
  requires 'traefik.enable',
           'traefik.start'
end


dep 'traefik.enable' do
  requires 'traefik.service',
           'traefik.compose'
end

dep 'traefik.start' do
  requires 'traefik.service'
end

dep 'traefik.service'

dep 'traefik.compose' do
  requires 'traefik.config',
           'traefik.acme'
end

dep 'traefik.config' do
  requires 'traefik.config directory'

  def files
    Dir.glob(TEMPLATE_ROOT / 'traefik/*.toml')
  end

  def installed_name(path)
    fname = File.basename(path)
    "/etc/traefik/#{fname}"
  end

  met? {
    files.all? do |path|
      renderable = Babushka::Renderable.new(installed_name(path))
      renderable.from? path
    end
  }

  meet {
    files.all? do |path|
      renderable = Babushka::Renderable.new(installed_name(path))
      renderable.render(path)
    end
  }
  after {
    shell 'systemctl restart traefik.service', :sudo => true
  }
end

dep 'traefik.acme' do
  requires 'traefik.config directory'
  acme_file = '/etc/traefik/acme.json'
  met? {
    acme_file.p.exists?
  }
  meet {
    shell "touch #{acme_file}"
  }
end

dep 'traefik.config directory' do
  met? {
    '/etc/traefik/'.p.exists?
  }
  meet {
    shell 'mkdir -p /etc/traefik/'
  }
end
