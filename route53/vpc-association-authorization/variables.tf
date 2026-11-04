variable "zone_id" {
  type        = string
  description = "(Required) - The ID of the private hosted zone to authorize the VPC association for. The zone must already exist in this account."
}

variable "vpc_id" {
  type        = string
  description = "(Required) - The ID of the VPC (in the OTHER account) being authorized to associate with the zone."
}

variable "vpc_region" {
  type        = string
  default     = null
  description = "(Optional) - The region of the VPC being authorized. Defaults to the provider's own region if omitted — set explicitly when the VPC is in a different region than this provider."
}
