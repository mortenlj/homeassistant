
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
dep 'traefik.compose'
