require 'tempfile'

# Creates a config file for docker-compose in a suitable location
meta :compose do
  template {
    requires 'docker-compose directory'

    base, _, _ = name.rpartition('.')
    fname = "#{base}.yml"
    renderable = Babushka::Renderable.new(compose_file(fname))

    met? {
      renderable.from? template_file(fname)
    }
    meet {
      renderable.render(template_file(fname), :context => self)
    }
  }
end

def compose_file(fname)
  "#{COMPOSE_LOCATION}/#{fname}"
end

def template_file(fname)
  "#{TEMPLATE_ROOT}/#{fname}"
end

COMPOSE_LOCATION = '/var/lib/docker-compose'
