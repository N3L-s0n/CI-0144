source "virtualbox-iso" "local-centos" {
    iso_url = "http://mirrors.ucr.ac.cr/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
    iso_checksum = "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"

    boot_command = [
        "<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-7-dhcp.ks<enter><wait>"
    ]

    http_directory  = "http"
    guest_os_type   = "RedHat_64"

    cpus = 1
    memory = 1024

    ssh_username    = var.alma_username
    ssh_password    = var.alma_password
    ssh_timeout     = "25m"

    shutdown_command = "echo 'packer'|sudo -S /sbin/halt -h -p"
    output_directory = "virtualbox-dev-centos"
}

source "vmware-iso" "esxi" {
    iso_url = "http://mirrors.ucr.ac.cr/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
    iso_checksum = "sha256:07b94e6b1a0b0260b94c83d6bb76b26bf7a310dc78d7a9c7432809fb9bc6194a"

    vm_name = "centos-7"
    vmdk_name = "centos-7-disk"

    cpus = 1
    memory = 1024

    # 20 GB disk size
    disk_size = 20480
    disk_type_id = "thin"

    cd_files = ["./http/centos-7-static.ks"]
    cd_label = "OEMDRV"

    boot_wait = "20s"
    boot_command = [
        "<tab><bs><bs><bs><bs><bs>text linux inst.ks=hd:/dev/sr1:centos-7-static.ks<enter><wait>"
    ]

    guest_os_type   = "centos-64"

    shutdown_command = "echo 'packer'|sudo -S /sbin/halt -h -p"

    # SSH Communicator  ======================
    communicator = "ssh"

    ssh_host        = var.alma_hostname
    ssh_username    = var.alma_username
    ssh_password    = var.alma_password
    ssh_timeout     = "25m"

    # ESXI Remote type =======================
    remote_type = "esx5"

    remote_host     = var.esxi_hostname
    remote_port     = var.esxi_hostport
    remote_username = var.esxi_username
    remote_password = var.esxi_password

    remote_datastore = var.esxi_datastore

    network_name = "WAN"

    # This must be set to "true" when using VNC with ESXi 6.5 or 6.7.
    vnc_disable_password = true

    format = "vmx"
    keep_registered = true
    vmx_remove_ethernet_interfaces = true

    output_directory = "vmware-esxi-centos"

}
