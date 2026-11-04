variable "name" {
  type        = string
  description = "(Required) A region-unique name for the copied AMI."
}

variable "region" {
  type        = string
  default     = null
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "source_ami_id" {
  type        = string
  description = "(Required) ID of the AMI to copy. This ID must be valid in the region given by source_ami_region. Must be shared (launch permission) with this account first if it lives in another account. That share is not managed by this module."

  validation {
    condition     = length(var.source_ami_id) > 4 && substr(var.source_ami_id, 0, 4) == "ami-"
    error_message = "The source_ami_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "source_ami_region" {
  type        = string
  description = "(Required) Region from which the AMI will be copied. This may be the same as the AWS provider region in order to create a copy within the same region."
}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) Longer, human-readable description for the AMI."
}

variable "deprecation_time" {
  type        = string
  default     = null
  description = "(Optional) Date and time to deprecate the AMI. If you specified a value for seconds, Amazon EC2 rounds the seconds to the nearest minute. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
}

variable "destination_outpost_arn" {
  type        = string
  default     = null
  description = "(Optional) ARN of the Outpost to which to copy the AMI. Only specify this parameter when copying an AMI from an AWS Region to an Outpost. The AMI must be in the Region of the destination Outpost."
}

variable "encrypted" {
  type        = bool
  default     = null
  description = "(Optional) Whether the destination snapshots of the copied image should be encrypted. The provider defaults to false."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "(Optional) Full ARN of the KMS Key to use when encrypting the snapshots of an image during a copy operation. If not specified, then the default AWS KMS Key will be used."
}

variable "timeouts" {
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = "(Optional) Operation timeouts. The provider defaults are create 40m, update 40m and delete 90m."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}
