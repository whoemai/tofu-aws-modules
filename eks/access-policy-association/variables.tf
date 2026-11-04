variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster."
}

variable "policy_arn" {
  type        = string
  description = "(Required) ARN of the access policy to associate (e.g. arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy)."
}

variable "principal_arn" {
  type        = string
  description = "(Required) IAM Principal ARN which requires authentication access to the EKS cluster."
}

variable "access_scope_type" {
  type        = string
  description = "(Required) Scope of the access. Valid values: namespace, cluster."

  validation {
    condition     = contains(["namespace", "cluster"], var.access_scope_type)
    error_message = "access_scope_type must be either namespace or cluster."
  }
}

variable "access_scope_namespaces" {
  type        = list(string)
  default     = null
  description = "(Optional) Namespaces the access scope applies to when access_scope_type is namespace."
}
