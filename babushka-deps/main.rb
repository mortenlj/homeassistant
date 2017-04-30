dep 'main' do
  requires 'apps',
           'docker',
           'autoupdate',
           'services',
           'timezone',
           'locale',
           'network-disks'
end

TEMPLATE_ROOT = "#{File.dirname(__FILE__)}/renderables"
CODE_ROOT = File.dirname(File.dirname(__FILE__))
