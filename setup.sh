#! /bin/bash

apt install openssh-server -y
systemctl start sshd

useradd -m -s /bin/bash ssh-user
while [ 1 ]; do
  read -s -p "Password: " pw
  read -s -p "Confirm: " cpw
  if [ $pw == $cpw ]; then
    break
  else
    echo "Passwords do not match"
  fi
done

echo ssh-user:$pw | chpasswd
mkdir /home/ssh-user/.ssh
touch /home/ssh-user/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxm2qvXKjqVOqytO3r8MzlAoGVUP8AS31PaCkkpi7piFNhvRTQARDXoGdg5CRjT/tWvKzpufao9glVzTyKzOacS+UHJanbUIC1zqSaWeH4aITLcmqnpb+BmvtU/eGhx/pQJHPVraxv/Tls4Cmt4ptHBJXUx0S+ldFp6YCqFxMpKIe6Mx+DKFGyL0Eisn9PbDqQK10CyMcL6PIftdp42Q8Zm3J2F4KoQGlR6Ba02SnJN8c1H9o+dDJh3pjR5m5SJpRL1/Lk+DBnk/B/xC2CYFLtT4EBVVWD3u5bonuWcrTXICXYPPoHcl/PSEnYpnLv8QuYVrq8yIW9oCp+RfbtCv0DrO9gSFXa6/mWzs1jMXVYpxizOeJgIzBQxMC52oiyFeZIBdsfrcVvRdh4WrRWKm8N04wftfkukwTfuLvuos729ydBO+81xtJ9vk3cnc+uOmy/0kFRJ0ad2eJY464eFTss03dAm4kqm6Q91CsKTJdlkBxXM6za+zRn6MnTDqMuLJU=" > /home/ssh-user/.ssh/authorized_keys
chown ssh-user /home/ssh-user/.ssh
chown ssh-user /home/ssh-user/.ssh/authorized_keys
chmod 700 /home/ssh-user/.ssh
chmod 600 /home/ssh-user/.ssh/authorized_keys

apt install vsftpd -y

sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf
touch /srv/ftp/iloveftp.txt
echo iloveftp > iloveftp.txt
systemctl restart vsftpd

apt install apache2 -y
systemctl start apache2

echo "Hello World!" > /var/www/html/index.html

apt install bind9 dnsutils -y



apt install mariadb-server -y

