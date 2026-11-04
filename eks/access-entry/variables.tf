variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster."
}

variable "principal_arn" {
  type        = string
  description = "(Required) IAM Principal ARN which requires authentication access to the EKS cluster."
}

variable "kubernetes_groups" {
  type        = list(string)
  default     = null
  description = "(Optional) List of Kubernetes groups the principal belongs to when creating the access entry."
}

variable "type" {
  type        = string
  default     = null
  description = "(Optional) Defaults to STANDARD. Valid values: STANDARD, EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX. Non-STANDARD types disallow username/groups and prevent policy associations."
}

variable "user_name" {
  type        = string
  default     = null
  description = "(Optional) Defaults to principal ARN (or assume-role/session-name if a role is used)."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
