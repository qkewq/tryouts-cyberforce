#! /bin/bash

apt install openssh-server -y
systemctl start sshd

useradd -m -s /bin/bash ssh-user

echo ssh-user:password | chpasswd
mkdir /home/ssh-user/.ssh
touch /home/ssh-user/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxm2qvXKjqVOqytO3r8MzlAoGVUP8AS31PaCkkpi7piFNhvRTQARDXoGdg5CRjT/tWvKzpufao9glVzTyKzOacS+UHJanbUIC1zqSaWeH4aITLcmqnpb+BmvtU/eGhx/pQJHPVraxv/Tls4Cmt4ptHBJXUx0S+ldFp6YCqFxMpKIe6Mx+DKFGyL0Eisn9PbDqQK10CyMcL6PIftdp42Q8Zm3J2F4KoQGlR6Ba02SnJN8c1H9o+dDJh3pjR5m5SJpRL1/Lk+DBnk/B/xC2CYFLtT4EBVVWD3u5bonuWcrTXICXYPPoHcl/PSEnYpnLv8QuYVrq8yIW9oCp+RfbtCv0DrO9gSFXa6/mWzs1jMXVYpxizOeJgIzBQxMC52oiyFeZIBdsfrcVvRdh4WrRWKm8N04wftfkukwTfuLvuos729ydBO+81xtJ9vk3cnc+uOmy/0kFRJ0ad2eJY464eFTss03dAm4kqm6Q91CsKTJdlkBxXM6za+zRn6MnTDqMuLJU=" > /home/ssh-user/.ssh/authorized_keys
chown ssh-user /home/ssh-user/.ssh
chown ssh-user /home/ssh-user/.ssh/authorized_keys
chmod 700 /home/ssh-user/.ssh
chmod 600 /home/ssh-user/.ssh/authorized_keys
echo "SSH setup"

apt install vsftpd -y

sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
touch /srv/ftp/iloveftp.txt
echo iloveftp > /srv/ftp/iloveftp.txt
systemctl restart vsftpd
echo "FTP setup"

apt install apache2 -y
systemctl start apache2

echo "Hello World!" > /var/www/html/index.html
echo "Apache setup"

apt install bind9 dnsutils -y

echo -e "zone \"local\" {type master;file \"/etc/bind/db.local\";};" >> /etc/bind/named.conf.local
echo -e "test\tIN\tA\t10.10.10.10" >> /etc/bind/db.local
systemctl restart bind9
echo "DNS setup"

apt install mariadb-server -y

mariadb -u root -e "CREATE DATABASE cyberforce; CREATE TABLE cyberforce.supersecret (data INT NOT NULL DEFAULT 7);"
mariadb -u root -e "CREATE USER 'scoring-sql'@'%' IDENTIFIED BY 'password';"
mariadb -u root -e "GRANT SELECT ON cyberforce.supersecret TO 'scoring-sql'@'%'; FLUSH PRIVILEGES;"
sed -i 's/bind-address            = 127.0.0.1/bind-address=0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
echo "DB setup"

echo "----- DONE -----"
