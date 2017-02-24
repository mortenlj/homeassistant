# Creates a config file for docker-compose in a suitable location
meta :compose do
  template {
    base, _, _ = name.rpartition('.')
    fname = "#{base}.yml"
    met? {
      p = compose_file(fname).p
      p.exists? && p.read == template_file(fname).p.read
    }
    meet {
      template_file(fname).p.copy compose_file(fname)
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
