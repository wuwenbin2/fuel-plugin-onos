
class onos::service{

$manager_ip = $onos::manager_ip
Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 320,
	logoutput => 'true',
}

firewall {'221 onos':
      dport   => [6633, 6640, 6653, 8181, 8101,9876],
      proto  => 'tcp',
      action => 'accept',
}->
service{ 'onos':
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
}->

exec{ 'sleep 120 to stablize onos':
        command => 'sleep 120;'
}->

exec { 'wait onos ready':
      command   => "curl -o /dev/null --fail --silent --head -u karaf:karaf http://$manager_ip:8181/onos/ui",
      tries     => 60,
      try_sleep => 20,
}->

exec{ 'install onos features':
        command => "sh /opt/feature_install.sh;
        rm -rf /opt/feature_install.sh;",
}->

exec{ 'add onos auto start':
        command => 'echo "onos">>/opt/service',
}
}
