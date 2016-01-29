include onos


Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
        logoutput => "true",
}

case $::operatingsystem{
centos:{
        $neutron_ovs_agent='neutron-openvswitch-agent'
        $ovs_service='openvswitch'
        $cmd_remove_agent='chkconfig --del neutron-openvswitch-agent'
}
ubuntu:{
        $neutron_ovs_agent='neutron-plugin-openvswitch-agent'
        $ovs_service='openvswitch-switch'
        $cmd_remove_agent='update-rc.d neutron-plugin-openvswitch-agent remove'
}

}

$roles =  $onos::roles

if member($roles, 'primary-controller') {
cs_resource { "p_${neutron_ovs_agent}":
    ensure => absent,
    before => Service["shut down and disable Neutron's agent services"],
  }}
else{
exec{'remove neutron-openvswitch-agent auto start':
        command => "touch /opt/service;
        $cmd_remove_agent;
        sed -i /neutron-openvswitch-agent/d /opt/service",
        before => Service["shut down and disable Neutron's agent services"],
}
}


firewall{'222 vxlan':
      port   => [4789],
      proto  => 'udp',
      action => 'accept',
}->
service {"shut down and disable Neutron's agent services":
                name => $neutron_ovs_agent,
                ensure => stopped,
                enable => false,
}->
exec{'Stop the OpenvSwitch service and clear existing OVSDB':
        command =>  "service $ovs_service stop ;
        rm -rf /var/log/openvswitch/* ;
        rm -rf /etc/openvswitch/conf.db ;
        service $ovs_service start ;"

} ->
exec{'Set ONOS as the manager':
        command => "su -s /bin/sh -c 'ovs-vsctl set-manager tcp:${onos::manager_ip}:6640'",

}



$network_scheme=hiera(network_scheme)
$transformations=$network_scheme[transformations]
$add_port=filter_nodes($transformations,'bridge','br-ex')
$public_eth_hash=filter_hash($add_port,'name')
$public_eth=$public_eth_hash[0]

if member($roles, 'compute') {
file{ "/opt/portconfig.sh":
        ensure => file,
        content => template('onos/portconfig.sh.erb'),
}->
exec{ 'set port':
        command => "sh /opt/portconfig.sh;
        rm -rf /opt/portconfig.sh;",
        before => Exec['Set ONOS as the manager'],
        require => Exec['Stop the OpenvSwitch service and clear existing OVSDB'],
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
