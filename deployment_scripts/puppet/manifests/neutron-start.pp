include onos

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }



$access_hash = hiera('access', {})
$keystone_admin_tenant = $access_hash[tenant]

$neutron_config = hiera_hash('quantum_settings')
$nets = $neutron_config['predefined_networks']
$admin_floating_net =
    {"shared"=>false,
     "L2"=>
      {"network_type"=>"vxlan",
       "router_ext"=>true,
       "segment_id"=>"10000"},
     "L3"=> $nets['admin_floating_net']['L3'],
     "tenant"=>"admin"}
$admin_internal_net =
    {"shared"=>false,
     "L2"=>
      {"network_type"=>"vxlan",
       "router_ext"=>false,
       "segment_id"=>"500"},
     "L3"=> $nets['admin_internal_net']['L3'],
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

openstack::network::create_network{'admin_internal_net':
    netdata => $admin_internal_net,
} ->
  openstack::network::create_network{'admin_floating_net':
    netdata => $admin_floating_net,
} ->
  openstack::network::create_router{'router04':
    internal_network => 'admin_internal_net',
    external_network => 'admin_floating_net',
    tenant_name      => $keystone_admin_tenant,
}
}
