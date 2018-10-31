dep 'network-disks' do
  requires 'network-disks - make mountpoint',
           'network-disks - add to fstab'
  met? {
    mounts = raw_shell('mount', :sudo => true).stdout
    mounts.include?($mountpoint)
  }
  meet {
    shell 'mount -a'
  }
end

dep 'network-disks - make mountpoint' do
  requires 'apps'
  met? {
    $mountpoint.p.exists?
  }
  meet {
    shell "mkdir -p #{$mountpoint}"
  }
end

dep 'network-disks - add to fstab' do
  fstab_line = "emrys:/volume1/video #{$mountpoint} nfs rw,relatime,vers=4.0,rsize=131072,wsize=131072,namlen=255,hard,timeo=600,intr 0 0"
  met? {
    '/etc/fstab'.p.grep(fstab_line)
  }
  meet {
    '/etc/fstab'.p.append(fstab_line + "\n")
  }
end


$mountpoint = '/mnt/emrys/video'

