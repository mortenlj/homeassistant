# Creates a systemd service file from a template
meta :service do
  template {
    met? {
      p = service_file(name).p
      p.exists? && p.read == template_file(name).p.read
    }
    meet {
      template_file(name).p.copy service_file(name)
    }
    after {
      shell "systemctl stop #{basename}.service", :sudo => true
      shell "systemctl disable #{basename}.service", :sudo => true
    }
  }
end

meta :enable do
  template {
    met? {
      shell? "systemctl is-enabled #{basename}.service", :sudo => true
    }
    meet {
      shell "systemctl enable #{basename}.service", :sudo => true
    }
  }
end

meta :start do
  template {
    met? {
      raw_shell("systemctl is-active #{basename}.service", :sudo => true).stdout.strip == 'active'
    }
    meet {
      shell "systemctl start #{basename}.service", :sudo => true
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
