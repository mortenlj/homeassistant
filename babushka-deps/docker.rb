dep 'docker' do
  requires 'docker.bin'
end

dep 'docker.bin' do
  installs {
    via :apt, 'docker.io'
    otherwise 'docker'
  }
end
