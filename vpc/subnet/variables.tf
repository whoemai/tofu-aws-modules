variable "vpc_id" {
  type        = string
  default     = null
  description = "(Required) The VPC ID."
}

variable "cidr_block" {
  type        = string
  default     = null
  description = "(Optional) The IPv4 CIDR block for the subnet."

  validation {
    condition = (
      var.cidr_block != null ||
      (var.ipv4_ipam_pool_id != null && var.ipv4_netmask_length != null)
    )
    error_message = "cidr_block is required when ipv4_ipam_pool_id and ipv4_netmask_length are not set."
  }
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "(Optional) The AZ for the subnet."
}

variable "availability_zone_id" {
  type        = string
  default     = null
  description = "(Optional) The AZ ID for the subnet."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The maps of tags"
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
}

variable "assign_ipv6_address_on_creation" {
  type        = bool
  default     = false
  description = "(Optional) Assign IPv6 addresses to ENIs created in the subnet."
}

variable "ipv6_cidr_block" {
  type        = string
  default     = null
  description = "(Optional) IPv6 CIDR block for the subnet. Must be a /64."
}

variable "ipv6_native" {
  type        = bool
  default     = false
  description = "(Optional) Whether to create an IPv6-only subnet."
}

variable "enable_dns64" {
  type        = bool
  default     = false
  description = "(Optional) Enable DNS64 for IPv6-only subnets."
}

variable "enable_resource_name_dns_a_record_on_launch" {
  type        = bool
  default     = false
  description = "(Optional) Respond to DNS queries for instance hostnames with A records."
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  type        = bool
  default     = false
  description = "(Optional) Respond to DNS queries for instance hostnames with AAAA records."
}

variable "private_dns_hostname_type_on_launch" {
  type        = string
  default     = null
  description = "(Optional) DNS hostname type on launch. Valid values: ip-name, resource-name."
}

variable "ipv4_ipam_pool_id" {
  type        = string
  default     = null
  description = "(Optional) IPv4 IPAM pool ID for CIDR allocation."
}

variable "ipv4_netmask_length" {
  type        = number
  default     = null
  description = "(Optional) IPv4 netmask length when using ipv4_ipam_pool_id."
}

variable "ipv6_ipam_pool_id" {
  type        = string
  default     = null
  description = "(Optional) IPv6 IPAM pool ID for CIDR allocation."
}

variable "ipv6_netmask_length" {
  type        = number
  default     = null
  description = "(Optional) IPv6 netmask length when using ipv6_ipam_pool_id."
}

variable "outpost_arn" {
  type        = string
  default     = null
  description = "(Optional) Outpost ARN for the subnet."
}

variable "customer_owned_ipv4_pool" {
  type        = string
  default     = null
  description = "(Optional) Customer owned IPv4 pool for the subnet."
}

variable "map_customer_owned_ip_on_launch" {
  type        = bool
  default     = false
  description = "(Optional) Assign customer owned IPs on launch."
}

variable "enable_lni_at_device_index" {
  type        = number
  default     = null
  description = "(Optional) Device index for local network interfaces."
}