include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }


service {'start neutron service':
         name => "neutron-server",
         ensure => running
}

$roles =  $onos::roles

if member($roles, 'primary-controller') {


  exec{ 'sleep 20 to stablize neutron':
        command => 'sleep 20;',
	require => Service ['start neutron service']
  }->
  class {'onos::network::create_network':
  }->
  class {'onos::network::create_router':}

}
