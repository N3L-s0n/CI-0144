# ALMA Variables =====================

variable "alma_hostname" {
    type = string
    default = "172.24.133.27"
}

variable "alma_username" {
    type = string
    default = "packer"
}

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
