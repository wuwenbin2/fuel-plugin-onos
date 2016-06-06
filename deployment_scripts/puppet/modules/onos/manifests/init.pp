class onos{

  $nodes = hiera('nodes')
  $primary_controller = filter_nodes(  $nodes,'role','primary-controller')
  $roles = node_roles(  $nodes, hiera('uid'))
  $onos_hash = filter_nodes(  $nodes,'role','onos')
  $manager_ip = filter_hash(  $onos_hash, 'internal_address')
  $onos_names = filter_hash(  $onos_hash, 'name')
  $onos_home = '/opt/onos'
  $karaf_dist = 'apache-karaf-3.0.5'
  $onos_pkg_name = 'onos-1.6.0.tar.gz'
  $jdk8_pkg_name = 'jdk-8u51-linux-x64.tar.gz'
}
