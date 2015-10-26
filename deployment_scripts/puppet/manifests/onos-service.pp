
include firewall

class {'onos::config':} ~> 
class {'onos::service':}
