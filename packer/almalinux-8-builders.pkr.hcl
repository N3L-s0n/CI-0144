source "virtualbox-iso" "local-alma" {
    iso_url = "http://mirror.epn.edu.ec/almalinux/8.6/isos/x86_64/AlmaLinux-8.6-x86_64-minimal.iso"
    iso_checksum = "sha256:29111d9539830359aecec69ac12cf0e407c7500ffd0b9c46598b15e5fe1f4847"

    boot_command = [
        "<tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-8.ks<enter><wait>"
    ]
    http_directory = "http"
    guest_os_type  = "RedHat_64"

    cpus = 2
    memory = 1024

    ssh_username = var.secret_username
    ssh_password = var.secret_password
    ssh_timeout  = "25m"

    shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
    output_directory = "virtualbox-dev-alma"
}

source "vmware-iso" ""

build {

    name = "almalinux-image"

    sources = [
        "file.dev-ks",
        "virtualbox-iso.local-alma"
    ]k
}
