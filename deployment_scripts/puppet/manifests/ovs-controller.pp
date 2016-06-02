notice(' ONOS MODULAR: ovs-controller.pp')

include onos

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
        logoutput => "true",
}

$neutron_ovs_agent='neutron-openvswitch-agent'
$ovs_service='openvswitch-switch'

if roles_include(['primary-controller']) {
exec{'disable neutron openvswitch agent':
        command => "crm resource stop neutron-openvswitch-agent",
        before => Exec['Delete manager'],
  }}
else{

service {$neutron_ovs_agent:
        ensure => stopped,
        before => Exec['Delete manager'],
}
}


firewall{'222 vxlan':
      dport   => [4789, 4790],
      proto  => 'udp',
      action => 'accept',
}->

exec{'Delete manager':
        command =>  "ovs-vsctl del-manager",
}->


exec{'Delete br-prv':
        command =>  "ovs-vsctl del-br br-prv",
        onlyif  => "ovs-vsctl br-exists br-prv",
}->

exec{'Delete br-tun':
        command =>  "ovs-vsctl del-br br-tun",
        onlyif  => "ovs-vsctl br-exists br-tun",
}->

exec{'Delete br-int':
        command =>  "ovs-vsctl del-br br-int",
        onlyif  => "ovs-vsctl br-exists br-int",
}->

exec{'Delete br-floating':
        command => "ovs-vsctl del-br br-floating",
        onlyif  => "ovs-vsctl br-exists br-floating",

}->

exec{'Ovs show':
        command =>  "ovs-vsctl show",
}->

exec{'Set ONOS as the manager':
        command => "ovs-vsctl set-manager tcp:${onos::manager_ip}:6640",

}->

exec{"sleep 5 for ovsconnect":
        command => "sleep 5",
}->
exec{"delete public port from ovs of controllers":
        command => "ovs-vsctl del-port br-int onos_port2",
}
