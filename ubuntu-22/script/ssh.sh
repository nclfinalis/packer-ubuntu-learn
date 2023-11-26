#!/bin/bash
mkdir -p /home/vagrant/.ssh
mv /home/vagrant/authorized_keys /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
service ssh restart