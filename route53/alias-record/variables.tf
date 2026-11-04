variable "zone_id" {
  type        = string
  description = "(Required) - The ID of the hosted zone to contain this record."
}

variable "name" {
  type        = string
  description = "(Required) - The name of the record. Accepts an FQDN or a name relative to the zone; \"\" is the zone apex."
}

variable "type" {
  type        = string
  default     = "A"
  description = "(Optional) - A (IPv4) or AAAA (IPv6). One record per module instance — a hostname needing both needs two instances."

  validation {
    condition     = contains(["A", "AAAA"], var.type)
    error_message = "type must be A or AAAA — this module only supports those alias record types."
  }
}

variable "alias_target" {
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })
  description = "(Required) - Alias target. For CloudFront: name = the distribution's domain_name, zone_id = its hosted_zone_id (Z2FDTNDATAQYW2, a global constant — NOT your own hosted zone's id)."
}

variable "allow_overwrite" {
  type        = bool
  default     = true
  description = "(Optional) - Allow overwriting an existing record with the same name/type instead of failing on conflict. Defaults to true since the alias record is owned by this stack; be careful in a zone shared with external-dns."
}
