include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

$neutron_config = hiera_hash('quantum_settings')
$nets = $neutron_config['predefined_networks']
$net04_ext =
    {"shared"=>false,
     "L2"=>
      {"network_type"=>"vxlan",
       "router_ext"=>true,
       "segment_id"=>"10000"},
     "L3"=> $nets['net04_ext']['L3'],
     "tenant"=>"admin"}
$net04 =
    {"shared"=>false,
     "L2"=>
      {"network_type"=>"vxlan",
       "router_ext"=>false,
       "segment_id"=>"500"},
     "L3"=> $nets['net04']['L3'],
      "tenant"=>"admin"}
$roles =  $onos::roles
$network_type = 'vxlan'


service {'start neutron service':
         name => "neutron-server",
         ensure => running
}



if member($roles, 'primary-controller') {

    Service<| title == 'start neutron service' |> ->
      Openstack::Network::Create_network <||>

    Service<| title == 'start neutron service' |> ->
      Openstack::Network::Create_router <||>

openstack::network::create_network{'net04':
    netdata => $net04,
    segmentation_type => $network_type,
} ->
  openstack::network::create_network{'net04_ext':
    netdata => $net04_ext,
    segmentation_type => $network_type,
} ->
  openstack::network::create_router{'router04':
    internal_network => 'net04',
    external_network => 'net04_ext',
    tenant_name      => 'admin',
}
}
