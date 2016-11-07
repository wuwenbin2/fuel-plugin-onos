notice(' ONOS MODULAR: neutron-start.pp')

include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


service {'Start neutron service':
  name => "neutron-server",
  ensure => running
}

if roles_include(['primary-controller']) {

  exec{ 'Sleep 20 to stablize neutron':
    command => 'sleep 20;',
    require => Service ['Start neutron service']
  }->

  class {'onos::network::create_network':
  }->

  class {'onos::network::create_router':}

}
