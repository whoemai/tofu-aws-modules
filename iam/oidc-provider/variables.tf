variable "url" {
  type        = string
  description = "(Required, Forces new resource) URL of the identity provider, without a trailing slash."
}

variable "client_id_list" {
  type        = list(string)
  default     = ["sts.amazonaws.com"]
  description = "(Optional) List of client IDs (audiences) registered with the identity provider."
}

variable "thumbprint_list" {
  type        = list(string)
  default     = null
  description = "(Optional) Thumbprints of the identity provider's server certificate(s). Derived from the issuer's certificate when null."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key-value mapping of tags for the IAM OIDC provider."
}
