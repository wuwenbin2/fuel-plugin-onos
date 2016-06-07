#!/bin/bash

set -ux
source /root/openrc
/usr/bin/glance image-create --name 'TestSfcVm' --visibility 'public' --container-format='bare' --disk-format='qcow2' --min-ram='64'  --file '/root/firewall_block_image.img'

