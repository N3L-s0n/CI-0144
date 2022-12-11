# Nodes.tf
# defines virtual machines

resource "esxi_guest" "firewall" {

    guest_name  = "firewall"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.wan.name
    }

    network_interfaces {
        virtual_network = esxi_portgroup.nac.name
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
                        "firewall_public_ipv4"  = var.firewall["networks"]["wan"]["ipv4"],
                        "firewall_private_ipv4" = var.firewall["networks"]["lan"]["ipv4"],
                        "firewall_nac_ipv4"     = var.firewall["networks"]["nac"]["ipv4"],
                        "firewall_dmz_ipv4"     = var.firewall["networks"]["dmz"]["ipv4"],
                        "firewall_gateway_ipv4" = var.firewall["gateway"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }

    provisioner "remote-exec" {
        inline = ["sudo yum update -y"]

        connection {
            host        = self.ip_address
            type        = "ssh"
            user        = var.centos["username"]
            password    = var.centos_password
        }
    }
}

resource "esxi_guest" "dns_server" {

    guest_name =  "dns"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.dmz.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.dns["ipv4"],
                        "gateway_ipv4"      = var.firewall["networks"]["dmz"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "k8sserver" {
    guest_name =  "k8sserver"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 2 
    memsize     = 2048

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.dmz.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.k8sserver["ipv4"],
                        "gateway_ipv4"      = var.firewall["networks"]["dmz"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "freeipa" {
    guest_name =  "freeipa"

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 2 
    memsize     = 2048

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.freeipa["ipv4"],
                        "gateway_ipv4"      = var.firewall["networks"]["dmz"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "dhcp_servers" {
    count       = length(var.dhcp_cluster)
    guest_name  = var.dhcp_cluster[count.index]["name"]

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 1 
    memsize     = 1024

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.dhcp_cluster[count.index]["ipv4"],
                        "gateway_ipv4"      = var.firewall["networks"]["dmz"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}

resource "esxi_guest" "nodes" {
    count       = length(var.k8snodes)
    guest_name  = var.k8snodes[count.index]["name"]

    ovf_source = "../../images/packer/vmware-esxi-centos/centos-7.vmx"

    numvcpus    = 2 
    memsize     = 2048

    disk_store  = var.esxi["datastore"]

    network_interfaces {
        virtual_network = esxi_portgroup.lan.name
    }

    guestinfo = {
        "metadata" = base64gzip(templatefile("templates/cloud-init_nodes.tpl",
                    {
                        "node_private_ipv4" = var.k8snodes[count.index]["ipv4"]
                        "gateway_ipv4"      = var.firewall["networks"]["dmz"]["ipv4"]
                    }))
        "metadata.encoding" = "gzip+base64"
    }
}
