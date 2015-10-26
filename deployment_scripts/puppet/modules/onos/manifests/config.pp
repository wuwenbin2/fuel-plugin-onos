class onos::config{

file{ '/opt/onos/config/cluster.json':
        ensure => file,
#       source => "puppet:///modules/onos/files/cluster.json.erb",
        content => template('onos/cluster.json.erb')
}

file{ '/opt/onos/config/tablets.json':
        ensure => file,
#       source => "puppet:///modules/onos/files/tablets.json.erb",
        content => template('onos/tablets.json.erb'),
}
}

