variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster."
}

variable "fargate_profile_name" {
  type        = string
  description = "(Required) Name of the EKS Fargate Profile."
}

variable "pod_execution_role_arn" {
  type        = string
  description = "(Required) ARN of the IAM Role that provides permissions for the EKS Fargate Profile."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. Subnets must be tagged kubernetes.io/cluster/CLUSTER_NAME."
}

variable "selectors" {
  type = list(object({
    namespace = string
    labels    = optional(map(string))
  }))
  description = "(Required) List of selector blocks for choosing Kubernetes Pods to run with this Fargate Profile."

  validation {
    condition     = length(var.selectors) > 0
    error_message = "At least one selector is required."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
