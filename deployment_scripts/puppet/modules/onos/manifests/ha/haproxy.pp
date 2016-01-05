#
#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
class onos::ha::haproxy {


  Haproxy::Service        { use_include => true }
  Haproxy::Balancermember { use_include => true }

  $public_vip = hiera('public_vip')
  $management_vip = hiera('management_vip')
  $nodes = hiera('nodes')
  $primary_controller = filter_nodes($nodes,'role','primary-controller')
  $controllers = concat($primary_controller, filter_nodes($nodes,'role','controller'))
  $controllers_ip = filter_hash($controllers, 'internal_address')
  $controllers_names = filter_hash($controllers, 'name')

  # defaults for any haproxy_service within this class
  Openstack::Ha::Haproxy_service {
      internal_virtual_ip => $management_vip,
      ipaddresses         => $controllers_ip,
      public_virtual_ip   => $public_vip,
      server_names        => $controllers_names,
      public              => true,
      internal            => true,
  }

  openstack::ha::haproxy_service { 'onos':
    order                  => '221',
    listen_port            => '8181',
    haproxy_config_options => {
      'option'         => ['httpchk /onos/ui', 'httplog'],
      'timeout client' => '2h',
      'timeout server' => '2h',
      'balance'        => 'source',
      'mode'           => 'http'
    },
    balancermember_options => 'check inter 2000 fall 5',
  }
  
  exec { 'haproxy reload onos':
    command   => 'export OCF_ROOT="/usr/lib/ocf"; (ip netns list | grep haproxy) && ip netns exec haproxy /usr/lib/ocf/resource.d/fuel/ns_haproxy reload',
    path      => '/usr/bin:/usr/sbin:/bin:/sbin',
    logoutput => true,
    provider  => 'shell',
    tries     => 10,
    try_sleep => 10,
    returns   => [0, ''],
  }

  Haproxy::Listen <||> -> Exec['haproxy reload onos']
  Haproxy::Balancermember <||> -> Exec['haproxy reload onos']
}

