#ONOS Plugin for Fuel#

##Overview##

This plugin will install onos controller and let it be the manager for OVS.


* [ Open Network Operating System (ONOS) controller](https://wiki.onosproject.org/display/ONOS/Wiki+Home) is a controller of Software Define Network(SDN).


##Requirements##


        | Requirement                       | Version/Comment |
        |-----------------------------------|-----------------|
        | Mirantis OpenStack compatibility  | 6.1             |

##Limitations##


* Only supports the environment with network type: neutron with vlan.
* L2 traffic is the only function with ONOS.

##Installation Guide##


###ONOS plugin installation###


1.  Log in Fuel Master and clone GIT repository of fuel-plugin-onos from openstack:

        git clone https://github.com/stackforge/fuel-plugin-opendaylight

2. Preparing an environment for plugin development
in three easy steps:  
A. Install the standard Linux development tools.  
For Ubuntu 14.04 LTS, run:  

		`sudo apt-get install createrepo rpm dpkg-dev`  
For Centos 6.5, run:  

		`yum install createrepo rpm rpm-build dpkg-devel`  
B. Install the Fuel Plugin Builder. To do that, you should first get pip:

		`easy_install pip`  
C. Then, install Fuel Plugin Builder (fpb) itself:

        `pip install fuel-plugin-builder`
    
3. Build ONOS plugin for fuel:

        fpb --build fuel-plugin-onos/

4. The onos rpm will be built in the folder of fuel-plugin-onos.

5. Install the onos plugin:

        fuel plugins --install onos-[x.x.x].rpm

6. Check if you successfully install the plugin:

        fuel plugins

        id | name   | version | package_version
        ---|--------|---------|----------------
        1  | onos   | 0.1.1   | 2.0.0

     
7. Check if the plugin is enabled on the settings table.      
Note: the info of a new plugin can only be ready  when a new environment is created.


##User Guide##


###ONOS plugin configuration###


All action is with Fuel UI wizard.   
1. Create a new environment.   
2. Select 'onos plugin' on Settings tab.   
 
    ☑ onos plugin 

3. Select a node with role 'controller' and others with role 'compute'.
Note: In avoid of deployging failure, pay attentions to node configuration espacelly interfaces. 

        | interfaces   | useage                 |
        |--------------|------------------------|
        | eht0         | Admin(PXE)             |
        | eht1         | Storage and Management | 
        | eht2         | Private                | 
        | eht3         | Public                 | 

4. Click 'Deploy changes' to enable nodes with ONOS.  



###Dependencies###

In order to run ONOS, the following are required:  

- Java 8 JDK (Oracle Java recommended; OpenJDK is not as thoroughly tested)    
- ONOS tarball( Newest version 1.3 recommended.)

Note: In case of version problems, the onos rpm uses jdk and onos packages that have been tested.

###Testing###

1. Web UI is recommended for ONOS controller with tuitive information of topo, devices and etc.
for that purpose, IP address of the primary controller should be ready. The web will run into the log page after inputing the path, the username and password are both karaf. Now enjot ONOS!

        fuel node

        id | status | name             | cluster | ip        | mac               | roles                | pending_roles | online | group_id
        ---|--------|------------------|---------|-----------|-------------------|----------------------|---------------|--------|---------
        1  | ready  | Untitled (60:b8) | 1       | 10.20.0.1 | 52:54:00:00:60:b8 | ceph-osd, controller |               | True   | 1      
        2  | ready  | Untitled (23:6f) | 1       | 10.20.0.2 | 52:54:00:51:23:6f | ceph-osd, compute    |               | True   | 1     

 
	Web UI: http://controller_ip:8181/onos/ui/index.html 
2. CLI is capable of more diverse functionality by running/opt/onos/bin/onos.More about CLI can be found in [The ONOS CLI](
https://wiki.onosproject.org/display/ONOS/The+ONOS+CLI).


##Getting Involved##

Interested in contributing? Follow [Fuel Plugins Development](
https://wiki.openstack.org/wiki/Fuel/Plugins).

##Contributors##

•	Wu Wenbin <wuwenbin2@huawei.com>  
•	Zhang Haoyu <zhanghaoyu7@huawei.com>

