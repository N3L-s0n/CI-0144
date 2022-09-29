build {

    name = "kickstarts"

    sources = [
        "file.almalinux-dhcp-ks",
        "file.almalinux-static-ks",
        "file.centos-dhcp-ks",
        "file.centos-static-ks"
    ]
}

build {

    name = "almalinux"

    sources = [
        "virtualbox-iso.local-alma",
        "vmware-iso.esxi-alma",
    ]

    provisioner "shell" {
        execute_command =  "echo 'packer'|{{.Vars}} sudo -S -E bash '{{.Path}}'"
        inline = [
            "yum -y install epel-release",
            "yum -y update",
            "yum -y install ansible"
        ]
    }

    provisioner "ansible-local" {
        playbook_file = "../ansible/setup-almalinux.yml"
        role_paths = [
            "../../ansible/roles/almalinux-8-setup",
            "../../ansible/roles/sshd-config"
        ]
    }

    provisioner "shell" {
        execute_command =  "echo 'packer'|{{.Vars}} sudo -S -E bash '{{.Path}}'"
        inline = [
            "yum remove ansible -y"
        ]
    }

    post-processor "vagrant" {

        keep_input_artifact = true
        output = "boxes/{{.BuildName}}.box"
    }
}

build {

    name = "centos"

    sources = [
        "virtualbox-iso.local-centos",
    ]

    provisioner "shell" {
        execute_command =  "echo 'packer'|{{.Vars}} sudo -S -E bash '{{.Path}}'"
        inline = [
            "yum -y install epel-release",
            "yum -y update",
            "yum -y install ansible"
        ]
    }

    provisioner "ansible-local" {
        playbook_file = "../ansible/setup-centos.yml"
        role_paths = [
            "../../ansible/roles/centos-7-setup",
            "../../ansible/roles/sshd-config"
        ]
    }

    provisioner "shell" {
        execute_command =  "echo 'packer'|{{.Vars}} sudo -S -E bash '{{.Path}}'"
        inline = [
            "yum remove ansible -y"
        ]
    }

    post-processor "vagrant" {

        keep_input_artifact = true
        output = "boxes/{{.BuildName}}.box"
    }
}
