class onos{

#$onos_settings = hiera('onos')
#$network_metadata = hiera_hash('network_metadata')
#$node_uid = hiera('uid')
#$onos_nodes_hash = get_nodes_hash_by_roles($network_metadata, ['onos'])
#$onos_mgmt_ips_hash = get_node_to_ipaddr_map_by_network_role($onos_nodes_hash, 'management')
#$manager_ip = values($onos_mgmt_ips_hash)
#$onos_nodes_names = keys($onos_mgmt_ips_hash)
#$node_internal_address = $onos_mgmt_ips_hash["node-${node_uid}"]
#$roles = hiera('roles')

$nodes = hiera('nodes')
$primary_controller = filter_nodes($nodes,'role','primary-controller')
$roles = node_roles($nodes, hiera('uid'))

$onos_hash = filter_nodes($nodes,'role','onos')
$manager_ip = filter_hash($onos_hash, 'internal_address')
$onos_names = filter_hash($onos_hash, 'name')

$onos_home = '/opt/onos'
$karaf_dist = 'apache-karaf-3.0.5'
$onos_pkg_name = 'onos-1.6.0.tar.gz'
$jdk8_pkg_name = 'jdk-8u51-linux-x64.tar.gz'
}
