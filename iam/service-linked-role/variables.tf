variable "aws_service_name" {
  type        = string
  description = "(Required, Forces new resource) The AWS service to which this role is attached, formatted as a service URL without the protocol prefix (e.g. spot.amazonaws.com)."
}

variable "custom_suffix" {
  type        = string
  default     = null
  description = "(Optional, Forces new resource) Additional string appended to the role name. Support varies by service."
}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) The description of the role."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key-value mapping of tags for the IAM role."
}
