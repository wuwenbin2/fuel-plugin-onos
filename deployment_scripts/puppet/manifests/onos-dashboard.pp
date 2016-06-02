notice(' ONOS MODULAR: onos-dashboard.pp')

$cluster_id = hiera('deployment_id')
$master_ip = hiera('master_ip')
$network_metadata = hiera_hash('network_metadata', {})
$os_public_vip = $network_metadata['vips']['public']['ipaddr']
$onos = hiera('onos')
$port = '8181'
$user = 'karaf'
$password = 'karaf'

$dashboard_name = 'Onos Dashboard'
$dashboard_desc = "Onos dashboard interface. Default credentials are ${user}/${password}"
$dashboard_link = "http://${os_public_vip}:${port}/onos/ui"

$json_hash = { title       => $dashboard_name,
               description => $dashboard_desc,
               url         => $dashboard_link, }

$json_message = inline_template('<%= require "json"; JSON.dump(@json_hash) %>')

exec { 'create_dashboard_link':
  command => "/usr/bin/curl -H 'Content-Type: application/json' -X POST \
-d '${json_message}' \
http://${master_ip}:8000/api/clusters/${cluster_id}/plugin_links",
}
