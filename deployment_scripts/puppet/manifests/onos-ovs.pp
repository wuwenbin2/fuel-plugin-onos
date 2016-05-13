include onos

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
        logoutput => "true",
}

service {'openvswitch-switch':
    ensure => running,
    enable => false,
}->

exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:${onos::manager_ip}:6640'",

}



$network_scheme=hiera(network_scheme)
$transformations=$network_scheme[transformations]
$add_port=filter_nodes($transformations,'bridge','br-ex')
$public_eth_hash=filter_hash($add_port,'name')
$public_eth=$public_eth_hash[0]

$network_metadata=hiera(network_metadata)
$vrouter=$network_metadata['vips']['vrouter']['ipaddr']

if roles_include(['compute']) {
file{ "/opt/portconfig.sh":
        ensure => file,
        content => template('onos/portconfig.sh.erb'),
}->
exec{ 'set port':
        command => "sh /opt/portconfig.sh;
        rm -rf /opt/portconfig.sh;",
        before => Exec['Set ONOS as the manager'],
        require => Service['openvswitch-switch'], 
}
}
else
{
exec{"sleep 20 for ovsconnect":
        command => "sleep 20",
        require => Exec['Set ONOS as the manager'],
}->
exec{"delete public port from ovs of controllers":
        command => "ovs-vsctl del-port br-int onos_port2",
}
}
