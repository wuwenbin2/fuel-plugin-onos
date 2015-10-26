#!bin/sh

    echo 'export ONOS_OPTS=debug' > /opt/onos/options;
    echo 'export ONOS_USER=root' >> /opt/onos/options;
    mkdir /opt/onos/var;
    mkdir /opt/onos/config;
    sed -i '/pre-stop/i\env JAVA_HOME=/usr/lib/jvm/java-8-oracle' /opt/onos/debian/onos.conf;
    sed -i '/pre-stop/i\export ONOS_APPS=ovsdb,vtnrsc,vtn,vtnweb,proxyarp' /opt/onos/debian/onos.conf;
    cp -rf /opt/onos/debian/onos.conf /etc/init/;
    cp -rf /opt/onos/debian/onos.conf /etc/init.d/;
    cp -rf /opt/onos/centos/onos /etc/init.d/;
