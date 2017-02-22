dep 'main' do
  requires 'nano.bin',
           'docker',
           'autoupdate',
           'services'
end

dep 'nano.bin'

TEMPLATE_ROOT = "#{File.dirname(__FILE__)}/../renderables"
