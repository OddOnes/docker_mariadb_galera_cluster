#!/bin/bash
set -e

(
sleep 5;
systemctl disable mariadb
systemctl start mariadb

expect -c '
    set timeout 10;
    spawn mariadb-secure-installation;
    expect "Enter current password for root (enter for none):";
    send -- "\n";
    expect "Switch to unix_socket authentication";
    send "n\n";
    expect "Change the root password?";
    send "Y\n";
    expect "New password:";
    send -- "'"${DB_ROOT_PASSWORD}"'\n";
    expect "Re-enter new password:";
    send -- "'"${DB_ROOT_PASSWORD}"'\n";
    expect "Remove anonymous users?";
    send "Y\n";
    expect "Disallow root login remotely?";
    send "Y\n";
    expect "Remove test database and access to it?";
    send "Y\n";
    expect "Reload privilege tables now?";
    send "Y\n";
    interact;'

systemctl stop mariadb

cat << EOF > /etc/my.cnf.d/server.cnf
[mysqld]
binlog_format=row
default_storage_engine=InnoDB
bind-address=0.0.0.0
innodb_flush_log_at_trx_commit=2

[galera]
# Mandatory settings
wsrep_on=ON
wsrep_provider=/usr/lib64/galera-4/libgalera_smm.so
wsrep_node_name=${HOSTNAME}
wsrep_node_address=${MY_IP}
wsrep_cluster_name=${GALERA_GROUP}
wsrep_cluster_address=gcomm://${GALERA_NODES}
wsrep_forced_binlog_format=row
wsrep_load_data_splitting=ON
wsrep_log_conflicts=ON
wsrep_trx_fragment_unit=rows
wsrep_trx_fragment_size=5000
wsrep_status_file=/var/lib/mysql/wsrep_status_file.log
EOF



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

echo "done."
) &

exec /usr/sbin/init