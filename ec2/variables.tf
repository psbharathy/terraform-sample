variable "subnet_private" {
    type        = list(string)
    default     = ["172.31.1.0/24","172.31.2.0/24"]
}
variable "dispatcher_ami_id" {
    type        = string
    default     = "ami-042e8287309f5df03"
}
variable "publisher_ami_id" {
    type        = string
    default     = "ami-042e8287309f5df03"
}
variable "author_ami_id" {
    type        = string
    default     = "ami-042e8287309f5df03"
}
variable "author_dispatcher_ami_id" {
    type        = string
    default     = "ami-042e8287309f5df03"
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances in each private subnet"
  type        = number
  default     = 1
}

variable "vpc_security_group_id" {
    type = string
    default = "sg-dbe1d298"
}
