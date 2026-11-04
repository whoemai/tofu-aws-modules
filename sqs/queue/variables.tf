variable "region" {
  type        = string
  default     = null
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "name" {
  type        = string
  default     = null
  description = "(Optional) Name of the queue. Queue names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. For a FIFO (first-in-first-out) queue, the name must end with the .fifo suffix. If omitted, the provider will assign a random, unique name. Conflicts with name_prefix."
}

variable "name_prefix" {
  type        = string
  default     = null
  description = "(Optional) Creates a unique name beginning with the specified prefix. Conflicts with name."

  validation {
    condition     = var.name_prefix == null || var.name == null
    error_message = "name_prefix conflicts with name: set only one of them."
  }
}

variable "content_based_deduplication" {
  type        = bool
  default     = null
  description = "(Optional) Enables content-based deduplication for FIFO queues."
}

variable "deduplication_scope" {
  type        = string
  default     = null
  description = "(Optional) Specifies whether message deduplication occurs at the message group or queue level. Valid values are messageGroup and queue (provider default: queue)."

  validation {
    condition     = var.deduplication_scope == null || contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "deduplication_scope must be messageGroup or queue."
  }
}

variable "delay_seconds" {
  type        = number
  default     = null
  description = "(Optional) Time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds."

  validation {
    condition     = var.delay_seconds == null || (var.delay_seconds >= 0 && var.delay_seconds <= 900)
    error_message = "delay_seconds must be between 0 and 900."
  }
}

variable "fifo_queue" {
  type        = bool
  default     = null
  description = "(Optional) Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
}

variable "fifo_throughput_limit" {
  type        = string
  default     = null
  description = "(Optional) Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are perQueue and perMessageGroupId (provider default: perQueue)."

  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "fifo_throughput_limit must be perQueue or perMessageGroupId."
  }
}

variable "kms_data_key_reuse_period_seconds" {
  type        = number
  default     = null
  description = "(Optional) Length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). The default is 300 (5 minutes)."

  validation {
    condition     = var.kms_data_key_reuse_period_seconds == null || (var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400)
    error_message = "kms_data_key_reuse_period_seconds must be between 60 and 86400."
  }
}

variable "kms_master_key_id" {
  type        = string
  default     = null
  description = "(Optional) ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK."
}

variable "max_message_size" {
  type        = number
  default     = null
  description = "(Optional) Limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 1048576 bytes (1024 KiB). The default for this attribute is 262144 (256 KiB)."

  validation {
    condition     = var.max_message_size == null || (var.max_message_size >= 1024 && var.max_message_size <= 1048576)
    error_message = "max_message_size must be between 1024 and 1048576."
  }
}

variable "message_retention_seconds" {
  type        = number
  default     = null
  description = "(Optional) Number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."

  validation {
    condition     = var.message_retention_seconds == null || (var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600)
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "policy" {
  type        = string
  default     = null
  sensitive   = true
  description = "(Optional) JSON policy for the SQS queue. Applied through the aws_sqs_queue_policy resource, which the provider documentation prefers over the policy argument of the queue. Set Version = \"2012-10-17\" explicitly in the document."
}

variable "receive_wait_time_seconds" {
  type        = number
  default     = null
  description = "(Optional) Time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately."

  validation {
    condition     = var.receive_wait_time_seconds == null || (var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20)
    error_message = "receive_wait_time_seconds must be between 0 and 20."
  }
}

variable "redrive_allow_policy" {
  type        = string
  default     = null
  description = "(Optional) JSON policy to set up the Dead Letter Queue redrive permission. Applied through the aws_sqs_queue_redrive_allow_policy resource, which the provider documentation prefers over the queue argument."
}

variable "redrive_policy" {
  type        = string
  default     = null
  description = "(Optional) JSON policy to set up the Dead Letter Queue. Accepts two key/val pairs: deadLetterTargetArn and maxReceiveCount (an integer, 5, and not a string, \"5\"). Applied through the aws_sqs_queue_redrive_policy resource, which the provider documentation prefers over the queue argument."
}

variable "sqs_managed_sse_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys. The provider only performs drift detection of its value when present in the configuration."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Map of tags to assign to the queue. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}

variable "visibility_timeout_seconds" {
  type        = number
  default     = null
  description = "(Optional) Visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30."

  validation {
    condition     = var.visibility_timeout_seconds == null || (var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200)
    error_message = "visibility_timeout_seconds must be between 0 and 43200."
  }
}
