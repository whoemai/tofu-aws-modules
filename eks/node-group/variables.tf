variable "cluster_name" {
  type        = string
  description = "(Required) Name of the EKS Cluster."
}

variable "node_role_arn" {
  type        = string
  description = "(Required) ARN of the IAM Role that provides permissions for the EKS Node Group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) Identifiers of EC2 Subnets to associate with the EKS Node Group."
}

variable "desired_size" {
  type        = number
  description = "(Required) Desired number of worker nodes."
}

variable "max_size" {
  type        = number
  description = "(Required) Maximum number of worker nodes."
}

variable "min_size" {
  type        = number
  description = "(Required) Minimum number of worker nodes."
}

variable "node_group_name" {
  type        = string
  default     = null
  description = "(Optional) Name of the EKS Node Group. If omitted, a random unique name is assigned. Conflicts with node_group_name_prefix."
}

variable "node_group_name_prefix" {
  type        = string
  default     = null
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with node_group_name."
}

variable "ami_type" {
  type        = string
  default     = null
  description = "(Optional) Type of AMI associated with the EKS Node Group."
}

variable "capacity_type" {
  type        = string
  default     = null
  description = "(Optional) Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT."
}

variable "disk_size" {
  type        = number
  default     = null
  description = "(Optional) Disk size in GiB for worker nodes."
}

variable "force_update_version" {
  type        = bool
  default     = null
  description = "(Optional) Force version update if existing pods are unable to be drained due to a pod disruption budget issue."
}

variable "instance_types" {
  type        = list(string)
  default     = null
  description = "(Optional) List of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]."
}

variable "labels" {
  type        = map(string)
  default     = null
  description = "(Optional) Key-value map of Kubernetes labels."
}

variable "release_version" {
  type        = string
  default     = null
  description = "(Optional) AMI version of the EKS Node Group. Defaults to latest version for the Kubernetes version."
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "(Optional) Kubernetes version. Defaults to the EKS Cluster Kubernetes version."
}

variable "launch_template" {
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = string
  })
  default     = null
  description = "(Optional) Configuration block with EC2 Launch Template settings. Either id or name must be specified. Conflicts with remote_access."
}

variable "remote_access" {
  type = object({
    ec2_ssh_key               = optional(string)
    source_security_group_ids = optional(list(string))
  })
  default     = null
  description = "(Optional) Configuration block with remote access settings. Conflicts with launch_template."
}

variable "update_config" {
  type = object({
    max_unavailable            = optional(number)
    max_unavailable_percentage = optional(number)
    update_strategy            = optional(string)
  })
  default     = null
  description = "(Optional) Configuration block with update settings. max_unavailable and max_unavailable_percentage are mutually exclusive."
}

variable "taints" {
  type = list(object({
    key    = string
    value  = optional(string)
    effect = string
  }))
  default     = []
  description = "(Optional) Kubernetes taints to apply to the nodes in the node group. Maximum of 50 taints per node group."
}

variable "node_repair_config" {
  type = object({
    enabled = optional(bool)
  })
  default     = null
  description = "(Optional) Node auto repair configuration for the node group."
}

variable "warm_pool_config" {
  type = object({
    max_group_prepared_capacity = optional(number)
    min_size                    = optional(number)
    pool_state                  = optional(string)
    reuse_on_scale_in           = optional(bool)
  })
  default     = null
  description = "(Optional) Configuration block with EC2 Auto Scaling warm pool settings. Including this enables the warm pool."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}
