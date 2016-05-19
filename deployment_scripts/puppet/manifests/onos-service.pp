notice('ONOS MODULAR: onos-service.pp')

include onos

class {'onos::config':} ->
class {'onos::service':}


