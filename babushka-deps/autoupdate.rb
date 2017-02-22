dep 'autoupdate' do
  requires 'unattended-upgrades.bin',
           'apt-listchanges.bin'
  met? {
    '/etc/apt/apt.conf.d/20auto-upgrades'.p.exists?
  }
  meet {
    shell 'dpkg-reconfigure -plow unattended-upgrades', :sudo => true
  }
end

dep 'unattended-upgrades.bin' do
  installs {
    via :apt, 'unattended-upgrades'
    otherwise { unsupported_platform! }
  }
end

dep 'apt-listchanges.bin' do
  installs {
    via :apt, 'apt-listchanges'
    otherwise { unsupported_platform! }
  }
end
