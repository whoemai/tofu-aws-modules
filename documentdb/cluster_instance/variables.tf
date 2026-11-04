variable "cluster_identifier" {
  type        = string
  description = "(Required) Cluster identifier. Also names the parameter group, the instances (<cluster_identifier>-<n>) and the final snapshot."
}

variable "engine_version" {
  type        = string
  description = "(Required) DocumentDB engine version (e.g. 5.0.0). Must match var.parameter_group_family."
}

variable "port" {
  type        = number
  default     = 27017
  description = "(Optional) Port the cluster accepts connections on. Changing it forces a new cluster."
}

variable "master_username" {
  type        = string
  description = "(Required) Master username. Changing it forces a new cluster."
}

variable "master_password" {
  type        = string
  sensitive   = true
  description = "(Required) Master password. DocumentDB rejects /, double quote and @; avoid URI-reserved characters too if it goes into a mongodb:// connection string."
}

variable "db_subnet_group_name" {
  type        = string
  description = "(Required) DB subnet group (RDS API — the same groups RDS uses). Changing it forces a new cluster."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "(Required) Security groups attached to the cluster — created outside this module (see vpc/security-group)."
}

variable "parameter_group_family" {
  type        = string
  default     = null
  description = "(Optional) Parameter group family (e.g. docdb5.0). Required when var.cluster_parameters is non-empty."
}

variable "cluster_parameters" {
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "pending-reboot")
  }))
  default     = []
  description = "(Optional) Cluster parameter overrides (e.g. [{ name = \"tls\", value = \"disabled\" }]). Empty = AWS default group for the family, no parameter group created. Static parameters (like tls) need apply_method = pending-reboot and only take effect after the instances reboot."

  validation {
    condition     = alltrue([for p in var.cluster_parameters : contains(["immediate", "pending-reboot"], p.apply_method)])
    error_message = "apply_method must be either immediate or pending-reboot."
  }
}

variable "storage_encrypted" {
  type        = bool
  description = "(Required) Encryption at rest. Changing it forces a new cluster."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "(Optional) KMS key ARN for encryption at rest. null = AWS-managed aws/rds key. Changing it forces a new cluster."
}

variable "storage_type" {
  type        = string
  default     = "standard"
  description = "(Optional) standard | iopt1 (I/O-Optimized)."

  validation {
    condition     = contains(["standard", "iopt1"], var.storage_type)
    error_message = "storage_type must be either standard or iopt1."
  }
}

variable "backup_retention_period" {
  type        = number
  description = "(Required) Days to retain automated backups (1-35)."
}

variable "preferred_backup_window" {
  type        = string
  default     = null
  description = "(Optional) Daily backup window in UTC (hh24:mi-hh24:mi). null = AWS picks one."
}

variable "preferred_maintenance_window" {
  type        = string
  default     = null
  description = "(Optional) Weekly maintenance window in UTC (ddd:hh24:mi-ddd:hh24:mi), used by the cluster and the instances. null = AWS picks one."
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "(Optional) Log types to export to CloudWatch: audit, profiler. Each also needs the matching parameter (audit_logs / profiler) enabled."
}

variable "deletion_protection" {
  type        = bool
  description = "(Required) Block deletion of the cluster through the API."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "(Required) false takes a final snapshot named <cluster_identifier>-final on destroy."
}

variable "instance_count" {
  type        = number
  description = "(Required) Number of instances. The first one created becomes the writer; the rest are read replicas."
}

variable "instance_class" {
  type        = string
  description = "(Required) Instance class (e.g. db.t4g.medium). Check availability with `aws docdb describe-orderable-db-instance-options`. Changing it is an in-place resize with a restart."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "(Optional) Apply minor engine upgrades automatically in the maintenance window."
}

variable "promotion_tier" {
  type        = number
  default     = 0
  description = "(Optional) Failover priority of the instances, 0 (highest) to 15."
}

variable "ca_cert_identifier" {
  type        = string
  default     = null
  description = "(Optional) CA certificate for TLS connections (e.g. rds-ca-rsa2048-g1). null = AWS default."
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "(Optional) Apply cluster and instance modifications now instead of in the next maintenance window."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The Tags to resource"
}
