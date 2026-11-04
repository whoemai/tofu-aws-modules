variable "name" {
  type        = string
  description = "(Required) Name of the cluster. Must be between 1-100 characters in length."
}

variable "role_arn" {
  type        = string
  description = "(Required) ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf."
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "(Optional) Desired Kubernetes master version. If omitted, the latest available version at resource creation is used."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) List of subnet IDs. Must be in at least two different availability zones."
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "(Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true."
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = null
  description = "(Optional) List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled."
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "(Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates."
}

variable "bootstrap_self_managed_addons" {
  type        = bool
  default     = null
  description = "(Optional) Install default unmanaged add-ons, such as aws-cni, kube-proxy, and CoreDNS during cluster creation. Defaults to true."
}

variable "deletion_protection" {
  type        = bool
  default     = null
  description = "(Optional) Whether to enable deletion protection for the cluster. Default: false."
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  default     = []
  description = "(Optional) List of the desired control plane logging to enable."
}

variable "force_update_version" {
  type        = bool
  default     = null
  description = "(Optional) Force version update by overriding upgrade-blocking readiness checks when updating a cluster."
}

variable "access_config" {
  type = object({
    authentication_mode                         = optional(string)
    bootstrap_cluster_creator_admin_permissions = optional(bool)
  })
  default     = null
  description = "(Optional) Configuration block for the access config associated with your cluster. See https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html."
}

variable "encryption_config" {
  type = object({
    resources        = list(string)
    provider_key_arn = string
  })
  default     = null
  description = "(Optional) Configuration block with encryption configuration for the cluster. `resources` must be `[\"secrets\"]`."
}

variable "kubernetes_network_config" {
  type = object({
    service_ipv4_cidr              = optional(string)
    ip_family                      = optional(string)
    elastic_load_balancing_enabled = optional(bool)
  })
  default     = null
  description = "(Optional) Configuration block with kubernetes network configuration for the cluster."
}

variable "compute_config" {
  type = object({
    enabled       = optional(bool)
    node_pools    = optional(list(string))
    node_role_arn = optional(string)
  })
  default     = null
  description = "(Optional) Configuration block with compute configuration for EKS Auto Mode."
}

variable "storage_config_block_storage_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether the block storage capability is enabled on your EKS Auto Mode cluster."
}

variable "outpost_config" {
  type = object({
    control_plane_instance_type = string
    outpost_arns                = list(string)
  })
  default     = null
  description = "(Optional) Configuration block representing your local Amazon EKS cluster on an AWS Outpost. Not available for clusters on the AWS cloud."
}

variable "upgrade_policy_support_type" {
  type        = string
  default     = null
  description = "(Optional) Support type to use for the cluster. Valid values: EXTENDED, STANDARD."
}

variable "zonal_shift_config_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether zonal shift is enabled for the cluster."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
