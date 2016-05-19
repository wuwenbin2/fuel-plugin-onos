notice('ONOS MODULAR: onos-install.pp')

include onos
class{ 'onos::install':}
