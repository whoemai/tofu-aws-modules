variable "transit_gateway_id" {
  type        = string
  description = "(Required) Transit Gateway ID."
}

variable "vpc_id" {
  type        = string
  description = "(Required) VPC ID."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) Subnet IDs for the attachment."
}

variable "dns_support" {
  type        = string
  default     = null
  description = "(Optional) Enable or disable DNS support: enable or disable."
}

variable "ipv6_support" {
  type        = string
  default     = null
  description = "(Optional) Enable or disable IPv6 support: enable or disable."
}

variable "appliance_mode_support" {
  type        = string
  default     = null
  description = "(Optional) Enable or disable appliance mode: enable or disable."
}

variable "security_group_referencing_support" {
  type        = string
  default     = null
  description = "(Optional) Enable or disable security group referencing: enable or disable."
}

variable "transit_gateway_default_route_table_association" {
  type        = bool
  default     = null
  description = "(Optional) Default route table association: true or false."
}

variable "transit_gateway_default_route_table_propagation" {
  type        = bool
  default     = null
  description = "(Optional) Default route table propagation: true or false."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags."
}

variable "name" {
  type        = string
  default     = ""
  description = "Optional Name tag value for the attachment."
}
