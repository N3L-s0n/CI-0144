# ESXI VARIABLES
variable "esxi" {
    type = map 
    default = {
        ipv4 = "172.24.131.18"
        port = "22"
        username = "nelson.alvarezcedeno"
        datastore = "vmstorage"
    }
}

# CentOS Image VARIABLES
variable "centos" {
    type = map
    default = {
        username = "packer"
    }
}


# Firewall VARIABLES
variable "firewall" {
    type = any
    default = {
        networks = {
            wan = {
                ipv4 = "172.24.133.24"
            }
            nac = {
                ipv4 = "172.24.5.24"
            }
            lan = {
                ipv4 = "192.168.24.1"
            }
            dmz = {
                ipv4 = "192.168.25.1"
            }
        }
        gateway = {
            ipv4 = "172.24.133.1"
        }
    }
}

variable "firewall_subnets" {
    type = list(string)
    default = ["192.168.24.0/24"]
}

# Kubernetes VARIABLES
variable "k8sserver" {
    type = map
    default = {
        ipv4 = "192.168.25.20"
    }
}

variable "k8snodes" {
    type = list
    default = [
        {
            name = "master"    
            ipv4 = "192.168.24.100"
        },
        {
            name = "node1"
            ipv4 = "192.168.24.101"
        },
        {
            name = "node2"
            ipv4 = "192.168.24.102"
        },
        {
            name = "node3"
            ipv4 = "192.168.24.103"
        }
    ]
}

# FreeIPA
variable "freeipa" {
    type = map  
    default = {
        ipv4 = "192.168.24.20"
    }
}

# DNS VARIABLES
variable "dns" {
    type = any
    default = {
        is_master = "yes"
        ipv4 = "192.168.25.10"
        cluster = [
            {
                name = "viking"
                domain = "ns1.apollo144.com."
                ipv4 = "192.168.25.10"
            },
            {
                name = "sputnik"
                domain = "ns2.apollo144.com."
                ipv4 = "192.168.9.10"
            },
            {
                name = "serenity"
                domain = "ns3.apollo144.com."
                ipv4 = "192.168.15.10"
            }
        ]
    }
}

# DHCP Cluster VARIABLES
variable "dhcp_cluster" {
    type = list
    default = [
        {
            name = "dhcp1"
            ipv4 = "192.168.24.10"
        },
        {
            name = "dhcp2"
            ipv4 = "192.168.24.11"
        }
    ]
}

# DHCP Config VARIABLES
variable "dhcp_config" {
    type = map
    default = {
        ipv4_range = {
            start = "192.168.24.150"
            end = "192.168.24.199"
        }
    }
}

# Network VARIABLES
variable "network" {
    type = map
    default = {
        wan = {
            ipv4 = "172.24.133.0"
            prefix = "24"
            gateway = "172.24.133.1"
        }
        nac = {
            ipv4 = "172.24.5.0"
            prefix = "24"
            gateway = "172.24.5.1"
        }
        lan = {
            ipv4 = "192.168.24.0"
            prefix = "24"
            gateway = "192.168.24.1"
        }
        dmz = {
            ipv4 = "192.168.25.0"
            prefix = "24"
            gateway = "192.168.25.1"
        }
    }
}