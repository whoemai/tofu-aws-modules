variable "name" {
  type        = string
  description = "(Required, Forces new resource) Name of the schedule."
}

variable "group_name" {
  type        = string
  default     = null
  description = "(Optional, Forces new resource) Name of the schedule group to associate with this schedule. When omitted, the `default` schedule group is used."
}

variable "description" {
  type        = string
  default     = null
  description = "(Optional) Brief description of the schedule."
}

variable "schedule_expression" {
  type        = string
  description = "(Required) Defines when the schedule runs: at(...), rate(...) or cron(...)."
}

variable "schedule_expression_timezone" {
  type        = string
  default     = "UTC"
  description = "(Optional) Timezone in which the scheduling expression is evaluated. Example: America/Sao_Paulo."
}

variable "state" {
  type        = string
  default     = "ENABLED"
  description = "(Optional) Specifies whether the schedule is enabled or disabled."
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "state must be either ENABLED or DISABLED."
  }
}

variable "start_date" {
  type        = string
  default     = null
  description = "(Optional) The date, in UTC, after which the schedule can begin invoking its target. Example: 2030-01-01T01:00:00Z."
}

variable "end_date" {
  type        = string
  default     = null
  description = "(Optional) The date, in UTC, before which the schedule can invoke its target. Example: 2030-01-01T01:00:00Z."
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "(Optional) ARN for the customer managed KMS key that EventBridge Scheduler will use to encrypt and decrypt your data."
}

variable "action_after_completion" {
  type        = string
  default     = "NONE"
  description = "(Optional) Action that applies to the schedule after completing invocation of the target."
  validation {
    condition     = contains(["NONE", "DELETE"], var.action_after_completion)
    error_message = "action_after_completion must be either NONE or DELETE."
  }
}

variable "flexible_time_window_mode" {
  type        = string
  default     = "OFF"
  description = "(Optional) Determines whether the schedule is invoked within a flexible time window."
  validation {
    condition     = contains(["OFF", "FLEXIBLE"], var.flexible_time_window_mode)
    error_message = "flexible_time_window_mode must be either OFF or FLEXIBLE."
  }
}

variable "flexible_time_window_maximum_window_in_minutes" {
  type        = number
  default     = null
  description = "(Optional) Maximum time window during which a schedule can be invoked. Ranges from 1 to 1440 minutes. Required when mode is FLEXIBLE."
}

variable "target_arn" {
  type        = string
  description = "(Required) ARN of the target of this schedule, such as a Lambda function or SQS queue."
}

variable "target_role_arn" {
  type        = string
  description = "(Required) ARN of the IAM role that EventBridge Scheduler will use for this target when the schedule is invoked."
}

variable "target_input" {
  type        = string
  default     = null
  description = "(Optional) Text, or well-formed JSON, passed to the target."
}

variable "retry_policy_maximum_event_age_in_seconds" {
  type        = number
  default     = 86400
  description = "(Optional) Maximum amount of time, in seconds, to continue to make retry attempts. Ranges from 60 to 86400."
}

variable "retry_policy_maximum_retry_attempts" {
  type        = number
  default     = 185
  description = "(Optional) Maximum number of retry attempts to make before the request fails. Ranges from 0 to 185."
}

variable "dead_letter_arn" {
  type        = string
  default     = null
  description = "(Optional) ARN of the SQS queue specified as the destination for the dead-letter queue."
}
