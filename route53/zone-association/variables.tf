variable "zone_id" {
  type        = string
  description = "(Required) - The ID of the private hosted zone (owned by another account) to associate this VPC with. A prior VPC association authorization for this zone_id/vpc_id pair must already exist, created by the zone-owning account."
}

variable "vpc_id" {
  type        = string
  description = "(Required) - The ID of the VPC (in this account) to associate with the zone."
}

variable "vpc_region" {
  type        = string
  default     = null
  description = "(Optional) - The region of the VPC. Defaults to the provider's own region if omitted."
}
