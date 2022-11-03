data "template_file" "ansible_firewall_host" {
    
    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.firewall]

    vars = {
        node_name           = esxi_guest.firewall.guest_name
        ansible_user        = var.centos_username 
        ansible_password    = var.centos_password
        ip                  = esxi_guest.firewall.ip_address
        extra_vars          = ""
    }
}

data "template_file" "ansible_dns_host" {

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.dns_server]

    vars = {
        node_name           = esxi_guest.dns_server.guest_name
        ansible_user        = var.centos_username 
        ansible_password    = var.centos_password
        ip                  = esxi_guest.dns_server.ip_address
        extra_vars          = ""
    }

}

data "template_file" "ansible_dhcp_host" {

    count = length(var.dhcps_ipv4)

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.dhcp_servers]

    vars = {
        node_name           = esxi_guest.dhcp_servers[count.index]["guest_name"]
        ansible_user        = var.centos_username 
        ansible_password    = var.centos_password
        ip                  = esxi_guest.dhcp_servers[count.index]["ip_address"]
        extra_vars          = ""
    }
}

data "template_file" "ansible_nodes_host" {
    
    count = length(var.nodes_private_ipv4)

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.nodes]

    vars = {
        node_name           = esxi_guest.nodes[count.index]["guest_name"]
        ansible_user        = var.centos_username
        ansible_password    = var.centos_password
        ip                  = esxi_guest.nodes[count.index]["ip_address"]
        extra_vars          = ""
    }
}

data "template_file" "ansible_skeleton" {
    
    template = file("${path.root}/templates/ansible_skeleton.tpl")
    depends_on = [data.template_file.ansible_firewall_host, data.template_file.ansible_nodes_host, data.template_file.ansible_dns_host, data.template_file.ansible_dhcp_host]

    vars = {
        firewall_host_def   = data.template_file.ansible_firewall_host.rendered
        dns_host_def        = data.template_file.ansible_dns_host.rendered
        dhcp_host_def       = join("", data.template_file.ansible_dhcp_host.*.rendered)
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
        apollo_tunnel = var.apollo_tunnel,
        wan_network = var.wan_network,
        lan_network = var.lan_network,
        dmz_network = var.dmz_network,
        firewall_private_ipv4 = var.firewall_private_ipv4,
        dhcp_md5_key = var.dhcp_md5_key,
        dhcp_range_start = var.dhcp_range_start,
        dhcp_range_end = var.dhcp_range_end,
    })

    filename = "${path.root}/variables.yml"
    file_permission = "0666"
}
