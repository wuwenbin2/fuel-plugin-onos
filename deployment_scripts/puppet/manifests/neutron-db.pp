notice(' ONOS MODULAR: neutron-db.pp')

include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'disable neutron l3 agent':
  command => "crm resource stop neutron-l3-agent",
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

