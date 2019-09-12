variable "availability_zones" {
  type        = list
  description = "This is a list of availability zones where private VPC subnets should be created."
}

variable "vpc_cidr_block" {
  type        = string
  description = "This is the CIDR block to be assigned to the private VPC that will be peered to the OMNI-VPC."
}

variable "group_tag" {
  type        = string
  description = "This value will be assigned to the group tag."
}

variable "description_tag" {
  type        = string
  description = "This value will be assigned to the description tag."
}
