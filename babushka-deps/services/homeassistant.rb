
dep 'homeassistant' do
  requires 'homeassistant.enable',
           'homeassistant.start'
end

dep 'homeassistant.enable' do
  requires 'homeassistant.service',
           'homeassistant.compose'
end

dep 'homeassistant.start' do
  requires 'homeassistant.service'
end

dep 'homeassistant.service'

dep 'homeassistant.compose' do
  requires 'homeassistant.docker-build'
end

dep 'homeassistant.docker-build' do
  met? {
    !raw_shell('docker images homeassistant -q').stdout.empty?
  }
  meet {
    shell 'docker build -t homeassistant .', :cd => File.join(CODE_ROOT, 'services'), :spinner => true
  }
end
