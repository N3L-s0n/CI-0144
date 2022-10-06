data "template_file" "ansible_firewall_host" {
    
    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.firewall]

    vars = {
        node_name       = esxi_guest.firewall.guest_name
        ansible_user    = var.alma_username 
        ip              = esxi_guest.firewall.ip_address
        extra_vars      = ""
    }
}

data "template_file" "ansible_nodes_host" {
    
    count = length(var.nodes_private_ipv4)

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.nodes]

    vars = {
        node_name       = esxi_guest.nodes[count.index]["guest_name"]
        ansible_user    = var.alma_username
        ip              = esxi_guest.nodes[count.index]["ip_address"]
        extra_vars      = ""
    }
}

data "template_file" "ansible_skeleton" {
    
    template = file("${path.root}/templates/ansible_skeleton.tpl")
    depends_on = [data.template_file.ansible_firewall_host, data.template_file.ansible_nodes_host]

    vars = {
        firewall_host_def   = data.template_file.ansible_firewall_host.rendered
        nodes_host_def      = join("", data.template_file.ansible_nodes_host.*.rendered)
    }
}

resource "local_file" "ansible_inventory" {
    
    depends_on = [data.template_file.ansible_skeleton]

    content = data.template_file.ansible_skeleton.rendered
    filename = "${path.root}/inventory"
    file_permission = "0666"
}

resource "local_file" "ansible_variables" {

    depends_on = [resource.esxi_guest.firewall]
    
    content = templatefile("${path.root}/templates/ansible_variables.tpl", {
        my_ipv4             = esxi_guest.firewall.ip_address,
        my_subnets          = var.firewall_subnets,

        serenity_ipv4       = "172.24.133.13",
        serenity_left_key   = var.serenity_left_key,
        serenity_right_key  = var.serenity_right_key,

        sputnik_ipv4        = "172.24.133.8",
        sputnik_left_key    = var.sputnik_left_key,
        sputnik_right_key   = var.sputnik_right_key,

        bastion_ipv4        = "172.24.131.43",
        bastion_left_key    = var.bastion_left_key,
        bastion_right_key   = var.bastion_right_key
    })

    filename = "${path.root}/variables.yml"
    file_permission = "0666"
}
