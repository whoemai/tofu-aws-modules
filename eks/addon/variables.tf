variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster."
}

variable "addon_name" {
  type        = string
  description = "(Required) Name of the EKS add-on (e.g. vpc-cni, coredns, kube-proxy, aws-ebs-csi-driver)."
}

variable "addon_version" {
  type        = string
  default     = null
  description = "(Optional) Version of the EKS add-on. Must match one of the versions returned by describe-addon-versions."
}

variable "configuration_values" {
  type        = string
  default     = null
  description = "(Optional) Custom configuration values for the add-on as a single JSON string."
}

variable "namespace" {
  type        = string
  default     = null
  description = "(Optional) Kubernetes namespace to install the add-on in. Once set, changing it requires removing and re-creating the add-on."
}

variable "preserve" {
  type        = bool
  default     = null
  description = "(Optional) Whether to preserve the created resources when deleting the EKS add-on."
}

variable "resolve_conflicts_on_create" {
  type        = string
  default     = null
  description = "(Optional) How to resolve field value conflicts when migrating a self-managed add-on. Valid values: NONE, OVERWRITE."
}

variable "resolve_conflicts_on_update" {
  type        = string
  default     = null
  description = "(Optional) How to resolve field value conflicts on add-on update. Valid values: NONE, OVERWRITE, PRESERVE."
}

variable "service_account_role_arn" {
  type        = string
  default     = null
  description = "(Optional) ARN of an existing IAM role to bind to the add-on's service account. Requires an IAM OIDC provider configured for the cluster."
}

variable "pod_identity_associations" {
  type = list(object({
    role_arn        = string
    service_account = string
  }))
  default     = []
  description = "(Optional) EKS Pod Identity association settings for the add-on."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
