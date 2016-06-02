notice(' ONOS MODULAR: ovs-update.pp')


package { 'openvswitch-datapath-dkms':
          ensure => '2.5.90-1',
}->
package { 'openvswitch-common':
          ensure => '2.5.90-1',
}->
package { 'openvswitch-switch':
          ensure => '2.5.90-1',
}
