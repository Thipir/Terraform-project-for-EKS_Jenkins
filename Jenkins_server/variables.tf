variable "vpc_cidr" {
  description = "jenkinsvpc CIDR"
  type        = string

}

variable "public_subnets" {
  description = "publicsubnets CIDR"
  type        = list(string)

}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string

}
