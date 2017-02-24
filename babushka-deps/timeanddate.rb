
TIMEZONE='/usr/share/zoneinfo/Europe/Oslo'

dep 'timezone' do
  p = '/etc/localtime'.p
  met? {
    p.exists? && p.symlink? && p.readlink == TIMEZONE
  }
  meet {
    p.unlink
    p.make_symlink(TIMEZONE)
  }
end
