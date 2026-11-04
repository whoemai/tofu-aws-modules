variable "target_group_arn" {
  description = "ARN of the target group to register the target with"
  type        = string
}

variable "target_id" {
  description = "ID of the target — instance ID (target_type instance), IP address (target_type ip), or Lambda ARN (target_type lambda)"
  type        = string
}

variable "port" {
  description = "Port on which the target receives traffic. Null uses the target group's own port."
  type        = number
  default     = null
}
