#!/bin/bash
set -e

(
sleep 5;

systemctl disable mariadb
systemctl disable garb

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --new-zone=docker_internal --permanent
firewall-cmd --zone=docker_internal --add-source=172.30.0.0/24 --permanent
firewall-cmd --zone=docker_internal --add-service=mysql --permanent
firewall-cmd --zone=docker_internal --add-port=3306/tcp --permanent
firewall-cmd --zone=docker_internal --add-port=4444/tcp --permanent
firewall-cmd --zone=docker_internal --add-port=4567/tcp --permanent
firewall-cmd --zone=docker_internal --add-port=4567/udp --permanent
firewall-cmd --zone=docker_internal --add-port=4568/tcp --permanent
firewall-cmd --reload

cat << EOF > /etc/sysconfig/garb
GALERA_NODES=${GALERA_NODES}
GALERA_GROUP=${GALERA_GROUP}
EOF

echo "done."
) &

exec /usr/sbin/init
