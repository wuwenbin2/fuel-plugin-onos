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
        enable => false,
        before => Exec['Delete manager'],
}
}


firewall{'222 vxlan':
      dport   => [4789],
      proto  => 'udp',
      action => 'accept',
}->

exec{'Delete manager':
        command =>  "ovs-vsctl del-manager",
}->


exec{'Delete br-prv':
        command =>  "ovs-vsctl del-br br-prv",
}->

exec{'Delete br-int':
        command =>  "ovs-vsctl del-br br-int",
}->

exec{'Delete br-floating':
        command =>  "ovs-vsctl del-br br-floating",
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
