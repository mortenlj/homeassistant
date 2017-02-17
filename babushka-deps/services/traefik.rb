
dep 'traefik' do
  requires 'traefik.service',
           'traefik.compose'
end

dep 'traefik.service'
dep 'traefik.compose'
