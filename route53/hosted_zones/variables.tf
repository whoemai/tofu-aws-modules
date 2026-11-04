variable "name" {
  type        = string
  description = "(Required) This is the name of the hosted zone."
}

variable "comment" {
  type        = string
  description = "(Optional) A comment for the hosted zone. Defaults to 'Managed by Terraform'."
  default     = "Managed by Terraform"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags."
}

variable "vpcs" {
  type = list(object({
    vpc_id     = string
    vpc_region = string
  }))
  default     = []
  description = "(Optional) Configuration block(s) specifying VPC(s) to associate with a private hosted zone. Leave empty for a public hosted zone."
}

variable "delegation_set_id" {
  type        = string
  default     = null
  description = "(Optional) ID of the reusable delegation set to attach to the hosted zone. Only applies to public zones and cannot be used with `vpcs`."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "(Optional) Whether to destroy all records (except NS/SOA) in the zone when destroying it."
}
