
class onos::install
{

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 180,
}

file{ '/opt/onos-1.3.0.tar.gz':
        source => "puppet:///modules/onos/onos-1.3.0.tar.gz",
} ->
exec{ "unzip onos package":
        command => "tar -zvxf /opt/onos-1.3.0.tar.gz -C /opt/onos --strip-components 1 --no-overwrite-dir -k ",
} ->
file{ '/opt/networking-onos.tar':
        source =>"puppet:///modules/onos/networking-onos.tar",
} -> 
exec{ "unzip network package":
        command => "tar vxf /opt/networking-onos.tar -C /opt",
} -> 
exec{ "install onos driver":
        command => "sh /opt/networking-onos/install_driver.sh",
} ->
file{ "/opt/jdk-8u51-linux-x64.tar.gz":
        source => "puppet:///modules/onos/jdk-8u51-linux-x64.tar.gz",
} ->
file{ '/opt/install_jdk8.tar':
        source => "puppet:///modules/onos/install_jdk8.tar",
} ->
exec{ "unzip jdk package":
        command => "tar xf /opt/install_jdk8.tar -C /opt",
} ->
exec{ "install jdk":
        command => "sh /opt/install_jdk8/install_jdk8.sh",
} ->
file{ '/root/.m2/':
        ensure => 'directory',
        recurse => true,
} ->
file{ '/root/.m2/repository.tar':
        source => "puppet:///modules/onos/repository.tar",
} ->
exec{ "unzip repository":
        command => "tar xf /root/.m2/repository.tar -C /root/.m2/",
} ->
file{ '/opt/onos_config.sh':
        source => "puppet:///modules/onos/onos_config.sh",
} ->
exec{ 'install onos config':
        command => "sh /opt/onos_config.sh",
} ->
exec{ 'onos features':
        command => "sed -i '/^featuresBoot=/c\featuresBoot=config,standard,region,package,kar,ssh,management,webconsole,onos-api,onos-core,onos-incubator,onos-cli,onos-rest,onos-gui,onos-openflow' /opt/onos/apache-karaf-3.0.3/etc/org.apache.karaf.features.cfg",
}
}
