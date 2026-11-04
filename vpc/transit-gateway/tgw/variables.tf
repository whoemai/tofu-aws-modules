variable "description" {
  type    = string
  default = null
}

variable "amazon_side_asn" {
  type    = string
  default = null
}

variable "auto_accept_shared_attachments" {
  type    = string
  default = null
}

variable "default_route_table_association" {
  type    = string
  default = null
}

variable "default_route_table_propagation" {
  type    = string
  default = null
}

variable "dns_support" {
  type    = string
  default = null
}

variable "vpn_ecmp_support" {
  type    = string
  default = null
}

variable "multicast_support" {
  type    = string
  default = null
}

variable "security_group_referencing_support" {
  type    = string
  default = null
}

variable "encryption_support" {
  type    = string
  default = null
}

variable "transit_gateway_cidr_blocks" {
  type    = list(string)
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}
