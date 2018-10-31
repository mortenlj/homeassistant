# Creates a systemd service file from a template
meta :service do
  template {
    def service_file(fname)
      "#{SERVICE_ROOT}/#{fname}"
    end

    def template_file(fname)
      "#{$template_root}/#{fname}"
    end

    renderable = Babushka::Renderable.new(service_file(name))
    met? {
      renderable.from? template_file('service.erb')
    }
    meet {
      renderable.render(template_file('service.erb'), opts.merge(:context => self))
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

SERVICE_ROOT = '/etc/systemd/system'
