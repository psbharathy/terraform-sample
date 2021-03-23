
variable "alb_security_groups" {
    type = string
    default = "sg-dbe1d298"
}
variable "subnet_prefixes" {
    type        = list(string)
    default     = ["172.31.1.0/24"]
}
variable "subnet_private" {
    type        = string
}

variable "vpc_id" {
    type = list(string)
    description = "The address space that is used by the virtual network."
    default     = ["172.31.0.0/16"]
}

variable "ec2_aem_dispatcher_one" {
    type        = string
    # default     = ["i-sdsds"]
}
variable "ec2_aem_dispatcher_two" {
    type        = string
    # default     = ["i-sdsds"]
}
variable "ec2_aem_author_dispatcher_one" {
    type        = string
    # default     = ["i-sdsds"]
}
variable "ec2_aem_author_dispatcher_two" {
    type        = string
    # default     = ["i-sdsds"]
}

