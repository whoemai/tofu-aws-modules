variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of security group IDs to assign to the Endpoint. Interface endpoints only; leave null for Gateway."
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of subnet group IDs to assign to the Endpoint. Interface endpoints only; leave null for Gateway."
}

variable "route_table_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of route table IDs that receive the route to the Endpoint. Gateway endpoints only (S3, DynamoDB); leave null for Interface."
}

variable "policy" {
  type        = string
  default     = null
  description = "(Optional) A JSON policy document to attach to the Endpoint. null keeps the AWS default (full access)."
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "(Required) The VPC ID."
}

variable "service_name" {
  type        = string
  default     = null
  description = "(Required) The Endpoint Name."
}

variable "vpc_endpoint_type" {
  type        = string
  default     = "Interface"
  description = "(Required) The Endpoint Type."
}

variable "private_dns_enabled" {
  type        = bool
  default     = true
  description = "(Required) Enable private DNS."
}

variable "service_region" {
  type        = string
  default     = null
  description = "(Optional) The AWS region of the VPC endpoint service, when it differs from the region this endpoint itself is created in. Required for cross-region PrivateLink; null keeps same-region behavior."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The maps of tags"
}