# ESXI Variables =====================
variable "esxi_hostname" {
    type = string 
    default = "172.24.131.18"
}

variable "esxi_hostport" {
    type = string 
    default = "22"
}

variable "esxi_username" {
    type = string 
    default = "nelson.alvarezcedeno"
}

variable "esxi_datastore" {
    type = string
    default = "vmstorage"
}

variable "centos_username" {
    type = string
    default = "packer"
}
# ====================================


# Firewall Variables =================
variable "firewall_public_ipv4" {
    type = string
    default = "172.24.133.24"
}

variable "firewall_private_ipv4" {
    type = string
    default = "192.168.24.1"
}

variable "firewall_dmz_ipv4" {
    type = string
    default = "192.168.25.1"
}

variable "firewall_gateway_ipv4" {
    type = string
    default = "172.24.133.1"
}

variable "firewall_subnets" {
    type = list(string)
    default = ["192.168.24.0/24"]
}
# ====================================

# Nodes Variables ====================
variable "nodes_private_ipv4" {
    type = list(string)
    default = ["192.168.24.10","192.168.24.11"]
}

# DNS Variables ======================
variable "dns_ipv4" {
    type = string
    default = "192.168.25.10"
}
# ====================================

# DHCP Variables =====================
variable "dhcps_ipv4" {
    type = list(string)
    default = ["192.168.24.20", "192.168.24.21"]
}
# ====================================

# Network Variables ==================

variable "wan_network" {
    type = string
    default = "172.24.133.0"
}

variable "lan_network" {
    type = string
    default = "192.168.24.0"
}

variable "dmz_network" {
    type = string
    default = "192.168.25.0"
}
# ====================================
