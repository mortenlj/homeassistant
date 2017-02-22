# Creates a systemd service file from a template
meta :service do
  template {
    met? {
      service_file(name).p.exists?
    }
    meet {
      template_file(name).p.copy service_file(name)
    }
  }
end

def service_file(fname)
  "#{SERVICE_ROOT}/#{fname}"
end

def template_file(fname)
  "#{TEMPLATE_ROOT}/#{fname}"
end

SERVICE_ROOT = '/etc/systemd/system'
