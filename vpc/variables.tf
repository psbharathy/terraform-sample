
variable "alb_security_groups" {
    type = string
    default = "sg-dbe1d298"
}
variable "vpc_id" {
    
    default = []
}
variable "cidr_vpc" {
    type = string
    default = "172.31.0.0/16"
}
variable "subnet_one_cidr_block" {
    type = string
    default = "172.31.1.0/24"
}
variable "subnet_two_cidr_block" {
    type = string
    default = "172.31.2.0/24"
}
variable "subnet_three_cidr_block" {
    type = string
    default = "172.31.3.0/24"
}
variable "subnet_four_cidr_block" {
    type = string
    default = "172.31.4.0/24"
}


