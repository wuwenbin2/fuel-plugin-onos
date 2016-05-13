class onos::config{
$onos_home = $onos::onos_home
$karaf_dist = $onos::karaf_dist
$roles =  $onos::roles
$public_vip = hiera('public_vip')
$management_vip = hiera('management_vip')
$manager_ip = $onos::manager_ip

$onos_pkg_name = $onos::onos_pkg_name
$jdk8_pkg_name = $onos::jdk8_pkg_name
  
Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
        logoutput => "true",
}

file{ '/opt/onos_config.sh':
        source => "puppet:///modules/onos/onos_config.sh",
} ->
exec{ 'install onos config':
        command => "sh /opt/onos_config.sh;
	rm -rf /opt/onos_config.sh;",
}->
exec{ "clean used files":
        command => "rm -rf /opt/$onos_pkg_name;
        rm -rf /opt/$jdk8_pkg_name
        rm -rf /root/.m2/*.tar"
}->
case $::operatingsystem {
   ubuntu:{
        file{'/etc/init/onos.conf':
        ensure => file,
        content => template('onos/debian/onos.conf.erb')
}}
    centos:{
        file{'/etc/init.d/onos':
        ensure => file,
        content => template('onos/centos/onos.erb'),
	mode => 0777
}}}

}
