FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN yum update -y;\
echo -e "[mariadb]\n\
name = MariaDB\n\
baseurl = https://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/yum/10.11/centos7-amd64\n\
gpgkey=https://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/yum/RPM-GPG-KEY-MariaDB\n\
gpgcheck=1\n" > /etc/yum.repos.d/MariaDB.repo;\
yum install -y epel-release;\
yum install -y MariaDB-server MariaDB-client rsync firewalld expect;

CMD ["/usr/sbin/init"]

 