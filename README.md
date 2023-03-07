# usage
## up
```
docker-compose up -d
```

## operation

### first node
```
docker exec -it db1 /bin/bash
[root@db1 /]# galera_new_cluster 
```

### other node
```
docker exec -it db2 /bin/bash
[root@db1 /]# systemctl start mariadb
```
```
docker exec -it db3 /bin/bash
[root@db1 /]# systemctl start mariadb
```

### arbitrator node
```
docker exec -it arbitrator /bin/bash
[root@arbitrator /]# systemctl start garb
```

## check table
```
docker exec -it db1 /bin/bash
[root@db1 /]# mysql -u root 
MariaDB [(none)]> select * from mysql.wsrep_cluster_members;
+--------------------------------------+--------------------------------------+-----------+-----------------------+
| node_uuid                            | cluster_uuid                         | node_name | node_incoming_address |
+--------------------------------------+--------------------------------------+-----------+-----------------------+
| 7670a545-bcb7-11ed-90c0-aaaaaaaaaaaa | 76721013-bcb7-11ed-ad0e-xxxxxxxxxxxx | db1       | 172.30.0.11:0         |
| 92e868f5-bcb7-11ed-84bd-bbbbbbbbbbbb | 76721013-bcb7-11ed-ad0e-xxxxxxxxxxxx | db2       | 172.30.0.12:0         |
| 996df66c-bcb7-11ed-8bcc-cccccccccccc | 76721013-bcb7-11ed-ad0e-xxxxxxxxxxxx | db3       | 172.30.0.13:0         |
| ae9ac3da-bcb7-11ed-8ccd-dddddddddddd | 76721013-bcb7-11ed-ad0e-xxxxxxxxxxxx | garb      |                       |
+--------------------------------------+--------------------------------------+-----------+-----------------------+
4 rows in set (0.002 sec)
```

# manual
https://mariadb.com/kb/en/what-is-mariadb-galera-cluster/