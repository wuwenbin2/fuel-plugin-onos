class onos{

$nodes_hash = hiera('nodes')
$primary_controller_hash = filter_nodes($nodes_hash,'role','primary-controller')
$ovs_manager_ip = $primary_controller_hash[0]['internal_address']
}
