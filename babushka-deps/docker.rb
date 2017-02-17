dep 'docker' do
  requires 'docker.bin',
           'docker-compose directory'
end

dep 'docker.bin' do
  installs {
    via :apt, 'docker.io'
    otherwise 'docker'
  }
end

dep 'docker-compose directory' do
  met? {
    '/var/lib/docker-compose'.p.exists?
  }
  meet {
    shell 'mkdir -p /var/lib/docker-compose', :sudo => true
  }
end
