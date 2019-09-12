variable "description_tag" {
  type        = string
  description = "This value will be assigned to the description tag."
}

variable "domains" {
  type        = list
  description = "List of domains to be registerd with Route53."
}

variable "group_tag" {
  type        = string
  description = "This value will be assigned to the group tag."
}
