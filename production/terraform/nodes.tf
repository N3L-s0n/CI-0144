# Nodes.tf
# defines virtual machines

resource "esxi_guest" "firewall" {

    guest_name  = "firewall"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi_datastore

    network_interfaces {
        virtual_network = esxi_portgroup.wan.name
    }

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    network_interfaces {
        virtual_network = esxi_portgroup.dmz.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_firewall.tpl", 
                    {
                        "firewall_public_ipv4"  = var.firewall_public_ipv4,
                        "firewall_private_ipv4" = var.firewall_private_ipv4,
                        "firewall_dmz_ipv4"     = var.firewall_dmz_ipv4,
                        "firewall_gateway_ipv4" = var.firewall_gateway_ipv4
                    }))
        "metadata.encoding" = "gzip+base64"
    }

    provisioner "remote-exec" {
        inline = ["sudo yum update -y"]

        connection {
            host        = self.ip_address
            type        = "ssh"
            user        = var.centos_username
            password    = var.centos_password
        }
    }
}

resource "esxi_guest" "dns_server" {

    guest_name =  "dns"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi_datastore

    network_interfaces {
        virtual_network = esxi_portgroup.dmz.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.dns_ipv4,
                        "gateway_ipv4"      = var.firewall_dmz_ipv4
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "dhcp_servers" {
    count       = length(var.dhcps_ipv4)
    guest_name  = "dhcp${count.index + 1}"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi_datastore

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = element(var.dhcps_ipv4, count.index),
                        "gateway_ipv4"      = var.firewall_private_ipv4
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "nodes" {
    count       = length(var.nodes_private_ipv4)
    guest_name  = "node${count.index + 1}"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi_datastore

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = element(var.nodes_private_ipv4, count.index),
                        "gateway_ipv4"      = var.firewall_private_ipv4
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}
