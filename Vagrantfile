VM_CPU = 4
VM_MEMORY = 4*1024 # MB

Vagrant.configure(2) do |config|
  config.vm.box = 'debian-13-uefi-amd64'

  config.vm.provider 'libvirt' do |lv, config|
    lv.cpus = VM_CPU
    lv.cpu_mode = 'host-passthrough'
    lv.memory = VM_MEMORY
    lv.keymap = 'pt'
    lv.disk_driver :discard => 'unmap', :cache => 'unsafe'
    config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: '4.2', nfs_udp: false
  end

  config.vm.provision 'shell', path: 'build.sh', args: [], name: 'build'
end
