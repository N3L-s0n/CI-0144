# This sources are used to write kickstart files using variables from .pkrvars.hcl files

# DHCP kickstart

source "file" "centos-dhcp-ks" {
    target = "./http/centos-7-dhcp.ks"

    content = <<EOF

# authentication options
auth --useshadow --passalgo=sha512

# partition options
autopart --type=lvm --fstype=ext4

# bootloader options
bootloader --append="crashkernel=auto" --location=mbr

# clear all partitions prior, and create default disk labels
clearpart --all --initlabel

# non-interactive installation
cmdline

# accept End User License Agreement (EULA)
eula --agreed

# enable firewall
firewall --enabled --service=ssh

# disable initial setup
firstboot --disabled

# Keyboard configuration
keyboard --vckeymap=us --xlayouts='us'
lang en_US

# System timezone
timezone Europe/Paris --isUtc

# Reboot after install
reboot

# Network configuration
network --bootproto=dhcp

# Root user password
rootpw --plaintext ${var.alma_password}

# SELinux configuration
selinux --enforcing

# Dont configure X on the system
skipx
zerombr

# Create new user
user --name=${var.alma_username} --plaintext --password=${var.alma_password}

# Services 
services --enabled=NetworkManager,sshd,chronyd

# SOFTWARE SELECTION
%packages --ignoremissing
@core
@base
@Development Tools
%end

# POST INSTALLATION SCRIPT
%post --nochroot --log=/mnt/sysimage/root/ks-post.log
    echo "${var.alma_username} ALL=(ALL) NOPASSWD: ALL" >> /mnt/sysimage/etc/sudoers.d/${var.alma_username}
%end

    EOF
}

source "file" "centos-static-ks" {
    target = "./http/centos-7-static.ks"

    content = <<EOF

# authentication options
auth --useshadow --passalgo=sha512

# partition options
autopart --type=lvm --fstype=ext4

# bootloader options
bootloader --append="crashkernel=auto" --location=mbr

# clear all partitions prior, and create default disk labels
clearpart --all --initlabel

# non-interactive installation
cmdline

# accept End User License Agreement (EULA)
eula --agreed

# enable firewall
firewall --enabled --service=ssh

# disable initial setup
firstboot --disabled

# Keyboard configuration
keyboard --vckeymap=us --xlayouts='us'
lang en_US

# System timezone
timezone Europe/Paris --isUtc

# Reboot after install
reboot

# Network configuration
network --bootproto=static --device=link --activate --ip=${var.alma_hostname} --netmask=255.255.255.0 --gateway=172.24.133.1 --nameserver=8.8.8.8,8.8.4.4

# Root user password
rootpw --plaintext ${var.alma_password}

# SELinux configuration
selinux --enforcing

# Dont configure X on the system
skipx
zerombr

# Create new user
user --name=${var.alma_username} --plaintext --password=${var.alma_password}

# Services 
services --enabled=NetworkManager,sshd,chronyd


# SOFTWARE SELECTION
%packages --ignoremissing
@core
@base
@Development Tools
%end

# POST INSTALLATION SCRIPT
%post --nochroot --log=/mnt/sysimage/root/ks-post.log
    echo "${var.alma_username} ALL=(ALL) NOPASSWD: ALL" >> /mnt/sysimage/etc/sudoers.d/${var.alma_username}
%end

    EOF
}
