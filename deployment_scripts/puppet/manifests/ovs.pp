
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
        before => Service['openvswitch-switch'],
  }}
else{

service {$neutron_ovs_agent:
        ensure => stopped,
        enable => false,
        before => Service['openvswitch-switch'],
}
}


firewall{'222 vxlan':
      dport   => [4789],
      proto  => 'udp',
      action => 'accept',
}->

service {'openvswitch-switch':
    ensure => stopped,
    enable => false,
}->

exec{'Delete log':
        command =>  "rm -rf /var/log/openvswitch/* ;"
}->


exec{'Clear existing OVSDB':
        command =>  "rm -rf /etc/openvswitch/conf.db ;"
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
}

