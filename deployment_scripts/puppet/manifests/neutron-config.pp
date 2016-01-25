include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


service {'stop neutron service':
         name => "neutron-server",
         ensure => stopped
}->

neutron_plugin_ml2 {
  'ml2/mechanism_drivers':       value => 'onos_ml2';
  'ml2/tenant_network_types':    value => 'vxlan';
  'ml2_type_vxlan/vni_ranges':   value => '100:50000';
  'onos/password':           value => 'admin';
  'onos/username':           value => 'admin';
  'onos/url_path':           value => "http://${onos::manager_ip}:8181/onos/vtn";
}->

package { 'install git':
  ensure => installed,
  name   => "git",
}->
file{ "/opt/networking-onos.tar":
        source => "puppet:///modules/onos/networking-onos.tar",
}->
file{ '/opt/onos_driver.sh':
        source => "puppet:///modules/onos/onos_driver.sh",
} ->
exec{ 'install onos driver':
        command => "sh /opt/onos_driver.sh;"

}->
neutron_config { 'DEFAULT/service_plugins':
        value => 'onos_router,neutron.services.metering.metering_plugin.MeteringPlugin';

}->
file{ "/etc/puppet/modules/openstack/manifests/network/create_network.pp":
        source => "puppet:///modules/onos/create_network.pp",
}->
file{ "/etc/puppet/modules/openstack/manifests/network/create_router.pp":
        source => "puppet:///modules/onos/create_router.pp",
}->
file{ "/etc/puppet/modules/osnailyfacter/lib/puppet/parser/functions/format_allocation_pools.rb":
        source => "puppet:///modules/onos/format_allocation_pools.rb",
}



