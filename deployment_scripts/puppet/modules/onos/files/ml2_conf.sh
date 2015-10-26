cat <<EOT>> /etc/neutron/plugins/ml2/ml2_conf.ini
[ml2_onos]
password = admin
username = admin
url_path = http://$::ipaddress:8181/onos/vtn
EOT
