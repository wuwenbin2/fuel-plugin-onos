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
}->

exec{ 'install onos driver':
        command => "sh /opt/onos_driver.sh;"
}->

neutron_config { 'DEFAULT/service_plugins':
        value => 'onos_router,neutron.services.metering.metering_plugin.MeteringPlugin';
}

if roles_include(['primary-controller']) {
  exec { 'disable neutron l3 agent':
    command => "crm resource stop neutron-l3-agent",
    require => Service ['stop neutron service'],
  }->

  exec { 'drop_neutron_db':
    command => "sudo mysql -e 'drop database if exists neutron;'",
  }->

  exec { 'create_neutron_db':
    command => "sudo mysql -e 'create database neutron character set utf8;'",
  }->

  exec { 'grant_neutron_db':
    command => "sudo mysql -e \"grant all on neutron.* to 'neutron'@'%';\"",
  }->

  exec { 'neutron_db_sync':
    command => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
  }
}
