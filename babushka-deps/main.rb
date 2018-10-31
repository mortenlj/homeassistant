dep 'main' do
  requires 'apps',
           'docker',
           'autoupdate',
           'services',
           'timezone',
           'locale',
           'network-disks'
end

$template_root = "#{File.dirname(__FILE__)}/renderables"
