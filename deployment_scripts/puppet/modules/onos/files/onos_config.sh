#!/bin/bash

set -eux
echo 'export ONOS_OPTS=debug' > /opt/onos/options;
echo 'export ONOS_USER=root' >> /opt/onos/options;
mkdir /opt/onos/var;
mkdir /opt/onos/config;

#jdk config

mkdir /usr/lib/jvm/
tar -xzf /opt/jdk-8u*-linux-x64.tar.gz -C /usr/lib/jvm/
mv /usr/lib/jvm/jdk1.8.0_* /usr/lib/jvm/java-8-oracle

touch /etc/profile.d/jdk.csh
cat <<EOT>> /etc/profile.d/jdk.csh
setenv J2SDKDIR /usr/lib/jvm/java-8-oracle
setenv J2REDIR /usr/lib/jvm/java-8-oracle/jre
setenv PATH ${PATH}:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin
setenv JAVA_HOME /usr/lib/jvm/java-8-oracle
setenv DERBY_HOME /usr/lib/jvm/java-8-oracle/db
EOT

touch /etc/profile.d/jdk.sh
cat <<EOT>> /etc/profile.d/jdk.sh
export J2SDKDIR=/usr/lib/jvm/java-8-oracle
export J2REDIR=/usr/lib/jvm/java-8-oracle/jre
export PATH=$PATH:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export DERBY_HOME=/usr/lib/jvm/java-8-oracle/db
EOT

chmod +x /etc/profile.d/jdk*


touch /opt/feature_install.sh
cat <<EOT>> /opt/feature_install.sh
#!/bin/bash
set -eux
/opt/onos/bin/onos "feature:install onos-openflow"
sleep 1
/opt/onos/bin/onos "feature:install onos-openflow-base"
sleep 1
/opt/onos/bin/onos "feature:install onos-ovsdatabase"
sleep 1
/opt/onos/bin/onos "feature:install onos-ovsdb-base"
sleep 1
/opt/onos/bin/onos "feature:install onos-drivers-ovsdb"
sleep 1
/opt/onos/bin/onos "feature:install onos-ovsdb-provider-host"
sleep 1
/opt/onos/bin/onos "feature:install onos-app-vtn-onosfw"
sleep 2
/opt/onos/bin/onos "externalportname-set -n onos_port2"
EOT

