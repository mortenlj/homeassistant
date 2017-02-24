dep 'main' do
  requires 'nano.bin',
           'docker',
           'autoupdate',
           'services'
  # TODO:
  # - timezone
  # - Date from ntp
  # - locale
  # - locate/updatedb
end

dep 'nano.bin'

TEMPLATE_ROOT = "#{File.dirname(__FILE__)}/renderables"
CODE_ROOT = File.dirname(File.dirname(__FILE__))
