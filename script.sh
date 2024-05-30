#!/bin/bash

sudo su
  #touch /vagrant/kernel_version
  #uname -r > /vagrant/kernel_version
  yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
  yum --enablerepo elrepo-kernel install kernel-ml -y
  grub2-mkconfig -o /boot/grub2/grub.cfg
  grub2-set-default 0
  reboot
fi
