variable "cidr_block" {
  type        = string
  default     = "0.0.0.0/0"
  description = "(Required) The CIDR block for the VPC."

}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "(Optional) A tenancy option for instances launched into the VPC. Default is default, which makes your instances shared on the host. Using either of the other options (dedicated or host) costs at least $2/hr."

}

variable "enable_dns_support" {
  type        = bool
  default     = false
  description = "(Optional) A boolean flag to enable/disable DNS support in the VPC. Defaults false."

}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."

}

# variable "enable_classiclink" {
#     type        = bool
#     default     = null
#     description = "(Optional) A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic."

# }

# variable "enable_classiclink_dns_support" {
#     type        = bool
#     default     = null
#     description = " (Optional) A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic."

# }

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  default     = false
  description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false."

}

variable "vpc_block_public_access_manage" {
  type        = bool
  default     = false
  description = "Whether to manage VPC Block Public Access options at the account and region level."
}

variable "vpc_block_public_access_internet_gateway_block_mode" {
  type        = string
  default     = "block-ingress"
  description = "Block mode for VPC Block Public Access. Allowed values: block-bidirectional, block-ingress, off."
}

variable "vpc_block_public_access_exclusion_enabled" {
  type        = bool
  default     = true
  description = "Whether to create a VPC Block Public Access exclusion for this VPC."
}

variable "vpc_block_public_access_exclusion_mode" {
  type        = string
  default     = "allow-egress"
  description = "Exclusion mode for VPC Block Public Access. Allowed values: allow-egress, allow-bidirectional."
}

variable "name" {
  type        = string
  default     = ""
  description = "The name of VPC."
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}