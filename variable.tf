variable "rg_name" {
    type = string 
}

variable "rg_location" {
    type = string
}

variable "vnet_name" {
    type = string
}

variable "address_space" {
    type = list(string)
}

variable "subnet1_name" {
    type = string   
}

variable "address_prefix1" {
    type = list(string)
}

variable "nic1_name" {
    type = string 
}

variable "vm1_name" {
   type = string
}

variable "nsg1_name" {
   type = string
}
