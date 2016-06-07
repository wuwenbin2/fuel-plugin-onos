notice(' ONOS MODULAR: onos-uploadvm.pp')


file { "/root/firewall_block_image.img":
  source => "puppet:///modules/onos/firewall_block_image.img",
}->


file { '/root/upload_vm.sh':
  source => "puppet:///modules/onos/upload_vm.sh",
}

exec {'source openrc':
  command => "/bin/bash '/root/upload_vm.sh'",
  path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  logoutput => true,
}
