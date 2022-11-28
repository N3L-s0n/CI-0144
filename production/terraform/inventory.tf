data "template_file" "ansible_firewall_host" {
    
    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.firewall]

    vars = {
        node_name           = esxi_guest.firewall.guest_name
        ansible_user        = var.centos["username"]
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
        ansible_user        = var.centos["username"]
        ansible_password    = var.centos_password
        ip                  = esxi_guest.dns_server.ip_address
        extra_vars          = "ismaster=${var.dns["is_master"]}"
    }

}

data "template_file" "ansible_dhcp_host" {

    count = length(var.dhcp_cluster)

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.dhcp_servers]

    vars = {
        node_name           = esxi_guest.dhcp_servers[count.index]["guest_name"]
        ansible_user        = var.centos["username"]
        ansible_password    = var.centos_password
        ip                  = esxi_guest.dhcp_servers[count.index]["ip_address"]
        extra_vars          = ""
    }
}

data "template_file" "ansible_nodes_host" {
    
    count = length(var.k8snodes)

    template = file("${path.root}/templates/ansible_hosts.tpl")
    depends_on = [esxi_guest.nodes]

    vars = {
        node_name           = esxi_guest.nodes[count.index]["guest_name"]
        ansible_user        = var.centos["username"]
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

        wan_network = var.network["wan"]["ipv4"],
        nac_network = var.network["nac"]["ipv4"],
        lan_network = var.network["lan"]["ipv4"],
        dmz_network = var.network["dmz"]["ipv4"],

        firewall_private_ipv4 = var.firewall["networks"]["lan"]["ipv4"],
        dhcp_md5_key = var.dhcp_md5_key,
        dhcp_range_start = var.dhcp_config["ipv4_range"]["start"],
        dhcp_range_end = var.dhcp_config["ipv4_range"]["end"],
        dns_servers = var.dns["cluster"],
    })

    filename = "${path.root}/variables.yml"
    file_permission = "0666"
}
