notice('ONOS MODULAR: ovs-compute.pp')

include onos

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
        logoutput => "true",
}

$neutron_ovs_agent='neutron-openvswitch-agent'
$ovs_service='openvswitch-switch'

$network_scheme=hiera(network_scheme)
$transformations=$network_scheme[transformations]
$add_port=filter_nodes($transformations,'bridge','br-ex')
$public_eth_hash=filter_hash($add_port,'name')
$public_eth=$public_eth_hash[0]

$network_metadata=hiera(network_metadata)
$vrouter=$network_metadata['vips']['vrouter']['ipaddr']

service {$neutron_ovs_agent:
        ensure => stopped,
        enable => false,
}->

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
        onlyif  => "ovs-vsctl br-exists br-prv",
}->

exec{'Delete br-tun':
        command =>  "ovs-vsctl del-br br-tun",
        onlyif  => "ovs-vsctl br-exists br-tun",
}->

exec{'Delete br-int':
        command =>  "ovs-vsctl del-br br-int",
        onlyif => "ovs-vsctl br-exists br-int",
}->

exec{'Delete br-floating':
        command => "ovs-vsctl del-br br-floating",
        onlyif  => "ovs-vsctl br-exists br-floating",

}->

file{ "/opt/portconfig.sh":
        ensure => file,
        content => template('onos/portconfig.sh.erb'),
}->
exec{ 'set port':
        command => "sh /opt/portconfig.sh;
        rm -rf /opt/portconfig.sh;",
}->

exec{'Ovs show':
        command =>  "ovs-vsctl show",
}->

exec{'Set ONOS as the manager':
        command => "ovs-vsctl set-manager tcp:${onos::manager_ip}:6640",

}
