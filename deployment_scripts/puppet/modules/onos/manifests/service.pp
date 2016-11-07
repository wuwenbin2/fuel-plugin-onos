class onos::service{

  $manager_ip = $onos::manager_ip
  Exec {
    path      => "/usr/bin:/usr/sbin:/bin:/sbin",
    timeout   => 320,
    logoutput => 'true',
  }

  firewall {'221 onos':
    dport   => [6633, 6640, 6653, 8181, 8101, 9876],
    proto  => 'tcp',
    action => 'accept',
  }->

  exec { 'load onos':
    command => 'systemctl daemon-reload',
  }->

  service { 'onos':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }->

  exec { 'sleep 150 to stablize onos':
    command => 'sleep 150;'
  }->

  exec { 'wait onos ready':
    command   => "curl -o /dev/null --fail --silent --head -u karaf:karaf http://$manager_ip:8181/onos/ui",
    tries     => 60,
    try_sleep => 20,
  }->

  exec { 'install feature openflow':
    command => "/opt/onos/bin/onos 'feature:install onos-openflow-base';
    /opt/onos/bin/onos 'feature:install onos-openflow'",
    tries     => 3,
    try_sleep => 5,
  }->

  exec { 'install feature ovs':
    command => "/opt/onos/bin/onos 'feature:install onos-ovsdatabase';
    /opt/onos/bin/onos 'feature:install onos-ovsdb-base';
    /opt/onos/bin/onos 'feature:install onos-drivers-ovsdb';
    /opt/onos/bin/onos 'feature:install onos-ovsdb-provider-host';",
    tries     => 3,
    try_sleep => 2,
  }->


  exec { 'install feature onosfw':
    command => "/opt/onos/bin/onos 'feature:install onos-app-vtn-onosfw';
    /opt/onos/bin/onos 'externalportname-set -n onos_port2';",
    tries     => 3,
    try_sleep => 2,
  }->

  exec { 'add onos auto start':
    command => 'echo "onos">>/opt/service',
  }
}
