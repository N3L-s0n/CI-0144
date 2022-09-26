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
