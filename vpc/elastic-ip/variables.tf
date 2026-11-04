variable "vpc" {
  type        = bool
  default     = null
  description = "Deprecated. Use domain instead. If true, domain is set to vpc."
}

variable "domain" {
  type        = string
  default     = null
  description = "Elastic IP domain. Use vpc for VPC EIPs."

  validation {
    condition     = var.domain == null || contains(["vpc", "standard"], var.domain)
    error_message = "domain must be null, vpc, or standard."
  }
}

variable "tags" {
  type = map(any)
}
