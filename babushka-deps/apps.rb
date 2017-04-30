
dep 'apps' do
  requires 'nano.bin',
           'mlocate.bin',
           'nfs-common.bin'
end

dep 'nano.bin'

dep 'mlocate.bin' do
  provides 'locate', 'updatedb'
end

dep 'nfs-common.bin' do
  provides 'mount.nfs', 'umount.nfs'
end

