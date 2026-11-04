variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster to create the association in."
}

variable "namespace" {
  type        = string
  description = "(Required) Kubernetes namespace inside the cluster where the association is created."
}

variable "service_account" {
  type        = string
  description = "(Required) Name of the Kubernetes service account to associate the IAM credentials with."
}

variable "role_arn" {
  type        = string
  description = "(Required) ARN of the IAM role to associate with the service account."
}

variable "disable_session_tags" {
  type        = bool
  default     = null
  description = "(Optional) Disable the tags automatically added to the role session by EKS. Must be true when policy is specified."
}

variable "policy" {
  type        = string
  default     = null
  description = "(Optional) IAM policy in JSON format (escaped string) that further restricts this association's permissions. Requires disable_session_tags = true."
}

variable "target_role_arn" {
  type        = string
  default     = null
  description = "(Optional) ARN of the IAM role to be chained to the role specified in role_arn."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
