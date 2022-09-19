source "virtualbox-iso" "local-alma" {
    iso_url = "http://mirror.epn.edu.ec/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-minimal.iso"
    iso_checksum = "sha256:29111d9539830359aecec69ac12cf0e407c7500ffd0b9c46598b15e5fe1f4847"

    boot_command = [
        "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-8-dhcp.ks<enter><wait>"
    ]
    http_directory = "http"
    guest_os_type  = "RedHat_64"

    cpus = 2
    memory = 1024

    ssh_username = var.alma_username
    ssh_password = var.alma_password
    ssh_timeout  = "25m"

    shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
    output_directory = "virtualbox-dev-alma"
}

source "vmware-iso" "esxi-alma" {
    iso_url = "http://mirror.epn.edu.ec/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-minimal.iso"
    iso_checksum = "sha256:29111d9539830359aecec69ac12cf0e407c7500ffd0b9c46598b15e5fe1f4847"

    vm_name = "almalinux-8"
    vmdk_name = "almalinux-8-disk"

    cpus = 2
    memory = 1024

    # 20 GB disk size
    disk_size = 20480
    disk_type_id = "thin"

    cd_files = ["./http/almalinux-8-static.ks"]
    cd_label = "OEMDRV"

    boot_wait = "15s"
    boot_command = [
        "<tab> inst.text inst.ks=cdrom:/dev/sr1:/almalinux-8-static.ks<enter><wait>"
    ]

    guest_os_type   = "centos-64"

    shutdown_command = "echo 'packer' | sudo -S shutdown -P now"

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

    output_directory = "vmware-esxi-alma"
}
