dep 'main' do
  requires 'nano.bin',
           'mlocate.bin',
           'docker',
           'autoupdate',
           'services',
           'timezone',
           'locale'
end

dep 'nano.bin'
dep 'mlocate.bin' do
  provides 'locate', 'updatedb'
end

TEMPLATE_ROOT = "#{File.dirname(__FILE__)}/renderables"
CODE_ROOT = File.dirname(File.dirname(__FILE__))
