
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
  met? {
    !raw_shell('docker images home-assistant -q').stdout.empty?
  }
  meet {
    shell 'docker build -t home-assistant .', :cd => File.join(CODE_ROOT, 'services'), :spinner => true
  }
end
