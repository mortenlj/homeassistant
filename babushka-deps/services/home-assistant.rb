
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
  requires 'home-assistant.docker-build'
end

dep 'home-assistant.docker-build' do
  requires 'docker login'
  met? {
    !raw_shell('docker images mortenlj/home-assistant-rpi -q').stdout.empty?
  }
  meet {
    shell 'docker pull mortenlj/home-assistant-rpi', :spinner => true
  }
end
