variable "alarm_name" {
  type        = string
  description = "(Required) Descriptive name for the alarm. Must be unique within the AWS account."
}

variable "comparison_operator" {
  type        = string
  description = "(Required) Arithmetic operation used when comparing the statistic and the threshold. One of GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, GreaterThanUpperThreshold."
}

variable "evaluation_periods" {
  type        = number
  description = "(Required) Number of periods over which data is compared to the threshold."
}

variable "namespace" {
  type        = string
  description = "(Required) Namespace of the metric, e.g. `AWS/NetworkELB`."
}

variable "metric_name" {
  type        = string
  description = "(Required) Name of the metric, e.g. `HealthyHostCount`."
}

variable "period" {
  type        = number
  description = "(Required) Period in seconds over which the statistic is applied. Valid values are 10, 20, 30, or any multiple of 60."
}

variable "statistic" {
  type        = string
  default     = null
  description = "(Optional) Statistic to apply: SampleCount, Average, Sum, Minimum or Maximum. Mutually exclusive with `extended_statistic`."
}

variable "extended_statistic" {
  type        = string
  default     = null
  description = "(Optional) Percentile statistic (p0.0 through p100). Mutually exclusive with `statistic`."
}

variable "threshold" {
  type        = number
  default     = null
  description = "(Optional) Value against which the statistic is compared. Required for static-threshold alarms."
}

variable "datapoints_to_alarm" {
  type        = number
  default     = null
  description = "(Optional) Number of datapoints that must be breaching to trigger the alarm, within `evaluation_periods`. Defaults to `evaluation_periods` when null."
}

variable "dimensions" {
  type        = map(string)
  default     = {}
  description = "(Optional) Dimensions of the metric. CloudWatch treats each unique dimension combination as a separate metric and never aggregates over one that was not published, so this must match exactly the combination the emitting service uses. A combination that does not match leaves the alarm in INSUFFICIENT_DATA indefinitely instead of failing."
}

variable "treat_missing_data" {
  type        = string
  default     = null
  description = "(Optional) How to handle missing datapoints: missing, ignore, breaching or notBreaching. Null leaves the provider default (`missing`)."
}

variable "unit" {
  type        = string
  default     = null
  description = "(Optional) Unit of the metric."
}

variable "actions_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether actions are executed on state changes. Null leaves the provider default (`true`)."
}

variable "alarm_actions" {
  type        = list(string)
  default     = []
  description = "(Optional) ARNs to execute when the alarm transitions to ALARM."
}

variable "ok_actions" {
  type        = list(string)
  default     = []
  description = "(Optional) ARNs to execute when the alarm transitions to OK."
}

variable "insufficient_data_actions" {
  type        = list(string)
  default     = []
  description = "(Optional) ARNs to execute when the alarm transitions to INSUFFICIENT_DATA."
}

variable "alarm_description" {
  type        = string
  default     = null
  description = "(Optional) Description of the alarm."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Tags applied to the alarm."
}
