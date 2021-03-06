
dep 'home-assistant' do
  requires 'home-assistant.enable',
           'home-assistant.start'
end

dep 'home-assistant.enable' do
  requires 'home-assistant.service',
           'home-assistant.compose'
end

dep 'home-assistant.start' do
  requires 'home-assistant.service'
end

dep 'home-assistant.service'

dep 'home-assistant.compose' do
  requires 'home-assistant.docker-build',
           'home-assistant.config',
           'home-assistant.web'
end

dep 'home-assistant.docker-build' do
  requires 'docker login'
  met? {
    !raw_shell('docker images "mortenlj/home-assistant-rpi:${HOME_ASSISTANT_VERSION}" -q').stdout.empty?
  }
  meet {
    shell 'docker pull "mortenlj/home-assistant-rpi:${HOME_ASSISTANT_VERSION}"', :spinner => true
  }
  after {
    shell 'systemctl restart home-assistant.service', :sudo => true
  }
end

dep 'home-assistant.config' do
  requires 'home-assistant.config directory'

  def files
    Dir.glob($template_root / 'home-assistant/*.yaml')
  end

  def installed_name(path)
    fname = File.basename(path)
    "#{CONFIG_ROOT}#{fname}"
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
    shell 'systemctl restart home-assistant.service', :sudo => true
  }
end

dep 'home-assistant.web' do
  requires 'home-assistant.web directory'
  target = CONFIG_ROOT / 'www/linn.jpeg'
  source = $template_root / 'home-assistant/www/linn.jpeg'
  met? {
    target.exists?
  }
  meet {
    FileUtils.cp(source, target)
  }
end


dep 'home-assistant.web directory' do
  requires 'home-assistant.config directory'
  web_dir = CONFIG_ROOT / 'www'
  met? {
    web_dir.p.exists?
  }
  meet {
    shell "mkdir -p #{web_dir}"
  }
end


dep 'home-assistant.config directory' do
  met? {
    CONFIG_ROOT.p.exists?
  }
  meet {
    shell "mkdir -p #{CONFIG_ROOT}"
  }
end

CONFIG_ROOT = '/etc/home-assistant/'
