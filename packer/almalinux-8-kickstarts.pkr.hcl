# This sources are used to write kickstart files using variables from .pkrvars.hcl files

# DHCP kickstart

source "file" "almalinux-dhcp-ks" {
    target = "./http/almalinux-8-dhcp.ks"

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

# Reboot after install
reboot

# Network configuration
network --bootproto=dhcp

# Root user password
rootpw --plaintext ${var.secret-password}

# SELinux configuration
selinux --enforcing

# Dont configure X on the system
skipx
zerombr

# Create new user
user --name=${var.secret-username} --plaintext --password=${var.secret-password}

# Services 
services --enabled=NetworkManager,sshd,chronyd

# Repositories
repo --name=base --baseurl=http://ftp.sakura.ad.jp/almalinux/8.6/BaseOS/x86_64/os/ --cost=100
repo --name=appstream --baseurl=http://ftp.sakura.ad.jp/almalinux/8.6/AppStream/x86_64/os/ --cost=1000

# SOFTWARE SELECTION
%packages
@^minimal-environment
@Development Tools
%end

# POST INSTALLATION SCRIPT
%post --nochroot --log=/mnt/sysimage/root/ks-post.log
    echo "packer ALL=(ALL) NOPASSWD: ALL" >> /mnt/sysimage/etc/sudoers.d/packer
%end

    EOF
}

source "file" "almalinux-static-ks" {
    target = "./http/almalinux-8-dhcp.ks"

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

# Reboot after install
reboot

# Network configuration
network --bootproto=dhcp

# Root user password
rootpw --plaintext ${var.secret-password}

# SELinux configuration
selinux --enforcing

# Dont configure X on the system
skipx
zerombr

# Create new user
user --name=${var.secret-username} --plaintext --password=${var.secret-password}

# Services 
services --enabled=NetworkManager,sshd,chronyd

# Repositories
repo --name=base --baseurl=http://ftp.sakura.ad.jp/almalinux/8.6/BaseOS/x86_64/os/ --cost=100
repo --name=appstream --baseurl=http://ftp.sakura.ad.jp/almalinux/8.6/AppStream/x86_64/os/ --cost=1000

# SOFTWARE SELECTION
%packages
@^minimal-environment
@Development Tools
%end

# POST INSTALLATION SCRIPT
%post --nochroot --log=/mnt/sysimage/root/ks-post.log
    echo "packer ALL=(ALL) NOPASSWD: ALL" >> /mnt/sysimage/etc/sudoers.d/packer
%end

    EOF
}
