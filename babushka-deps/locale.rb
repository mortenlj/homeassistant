dep 'locale' do
  requires 'locale.gen nb_NO',
           'locale.gen en_US'
  met? {
    locales = raw_shell('locale -a', :sudo => true).stdout
    locales.include?('nb_NO.utf8') && locales.include?('en_US.utf8')
  }
  meet {
    shell 'locale-gen', :sudo => true
  }
end

dep 'locale.gen nb_NO' do
  met? {
    '/etc/locale.gen'.p.grep(/^nb_NO\.UTF-8 UTF-8/)
  }
  meet {
    '/etc/locale.gen'.p.append("nb_NO.UTF-8 UTF-8\n")
  }
end

dep 'locale.gen en_US' do
  met? {
    '/etc/locale.gen'.p.grep(/^en_US\.UTF-8 UTF-8/)
  }
  meet {
    '/etc/locale.gen'.p.append("en_US.UTF-8 UTF-8\n")
  }
end
