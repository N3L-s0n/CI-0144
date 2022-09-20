build {

    name = "kickstarts"

    sources = [
        "file.almalinux-dhcp-ks",
        "file.almalinux-static-ks",
    ]
}

build {

    name = "almalinux"

    sources = [
        "virtualbox-iso.local-alma",
        "vmware-iso.esxi-alma",
    ]

    provisioner "ansible" {
    
        playbook_file = "../ansible/setup.yml"
        use_proxy = false
        extra_arguments = [
            "--extra-vars", 
            "ansible_user=${var.alma_username} ansible_password=${var.alma_password}"
        ]
    }

    post-processor "vagrant" {

        keep_input_artifact = true
        output = "boxes/{{.BuildName}}.box"
    }
}
