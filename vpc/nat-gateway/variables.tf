variable "allocation_id" {
  type        = string
  default     = null
  description = "Elastic IP allocation ID for public NAT gateways. Required when connectivity_type is public."
}

variable "connectivity_type" {
  type        = string
  default     = "public"
  description = "Connectivity type for the NAT gateway. Valid values: public, private."

  validation {
    condition     = contains(["public", "private"], var.connectivity_type)
    error_message = "connectivity_type must be either public or private."
  }
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Subnet ID for a zonal NAT gateway. Required when availability_mode is zonal."
}

variable "availability_mode" {
  type        = string
  default     = "zonal"
  description = "Availability mode for the NAT gateway. Valid values: zonal, regional."

  validation {
    condition     = contains(["zonal", "regional"], var.availability_mode)
    error_message = "availability_mode must be either zonal or regional."
  }
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC ID for a regional NAT gateway. Required when availability_mode is regional."
}

variable "availability_zone_address" {
  type = list(object({
    allocation_ids       = list(string)
    availability_zone    = optional(string)
    availability_zone_id = optional(string)
  }))
  default     = []
  description = "Availability zone address blocks for regional NAT gateways (manual mode)."
}

variable "private_ip" {
  type        = string
  default     = null
  description = "Private IPv4 address to assign to the NAT gateway."
}

variable "secondary_allocation_ids" {
  type        = list(string)
  default     = null
  description = "Secondary allocation IDs for a zonal NAT gateway."
}

variable "secondary_private_ip_addresses" {
  type        = list(string)
  default     = null
  description = "Secondary private IPv4 addresses for a zonal NAT gateway."
}

variable "secondary_private_ip_address_count" {
  type        = number
  default     = null
  description = "Number of secondary private IPv4 addresses for a NAT gateway."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the NAT gateway."
}

variable "validate_public_allocation_id" {
  type        = bool
  default     = true
  description = "Whether to validate allocation_id requirements for public NAT gateways."

  validation {
    condition = (
      !var.validate_public_allocation_id ||
      (var.connectivity_type == "public" && var.availability_mode == "zonal" && var.allocation_id != null) ||
      (var.connectivity_type == "public" && var.availability_mode == "regional" && var.allocation_id == null) ||
      (var.connectivity_type == "private" && var.allocation_id == null)
    )
    error_message = "For public zonal NAT gateways, allocation_id is required. For public regional or private NAT gateways, allocation_id must be null."
  }
}

variable "validate_nat_gateway_mode" {
  type        = bool
  default     = true
  description = "Whether to validate availability_mode and connectivity_type requirements."

  validation {
    condition = (
      !var.validate_nat_gateway_mode ||
      (
        var.availability_mode == "zonal" &&
        var.subnet_id != null && var.subnet_id != "" &&
        (var.vpc_id == null || var.vpc_id == "")
      ) ||
      (
        var.availability_mode == "regional" &&
        var.connectivity_type == "public" &&
        var.vpc_id != null && var.vpc_id != "" &&
        (var.subnet_id == null || var.subnet_id == "")
      )
    )
    error_message = "Zonal NAT requires subnet_id (and no vpc_id). Regional NAT requires vpc_id, connectivity_type public, and no subnet_id."
  }
}
