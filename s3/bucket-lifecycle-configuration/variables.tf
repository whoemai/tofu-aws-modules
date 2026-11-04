variable "bucket" {
  description = "Name of an existing S3 bucket."
  type        = string
}

variable "expected_bucket_owner" {
  description = "(Deprecated by the provider) Account ID of the expected bucket owner. If the bucket is owned by a different account, the request fails with HTTP 403. Forces a new resource."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource is managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transition_default_minimum_object_size" {
  description = "Default minimum object size behavior applied to the lifecycle configuration: \"all_storage_classes_128K\" (provider default) or \"varies_by_storage_class\". Custom object_size_greater_than / object_size_less_than filters take precedence."
  type        = string
  default     = null

  validation {
    condition     = contains(["all_storage_classes_128K", "varies_by_storage_class"], coalesce(var.transition_default_minimum_object_size, "all_storage_classes_128K"))
    error_message = "transition_default_minimum_object_size precisa ser all_storage_classes_128K ou varies_by_storage_class."
  }
}

variable "rules" {
  description = <<-EOT
    Complete list of lifecycle rules for the bucket (this replaces any existing configuration), mirroring the aws_s3_bucket_lifecycle_configuration schema:
      id                                - unique rule identifier (max 255 characters)
      enabled                           - whether the rule is active (Enabled/Disabled)
      filter                            - objects the rule applies to; null applies to the whole bucket. Use at most one of prefix, tag, and, object_size_greater_than, object_size_less_than
        prefix                          - key prefix
        tag                             - single tag { key, value }
        object_size_greater_than        - minimum object size in bytes
        object_size_less_than           - maximum object size in bytes
        and                             - logical AND of two or more predicates: prefix, tags (map), object_size_greater_than, object_size_less_than
      expiration                        - current version expiration; set exactly one of date (RFC3339 full-date, e.g. 2023-08-22), days or expired_object_delete_marker
      transitions                       - list of transitions of current versions { date or days, storage_class }
      noncurrent_version_expiration     - { noncurrent_days, newer_noncurrent_versions (optional) }
      noncurrent_version_transitions    - list of { noncurrent_days, storage_class, newer_noncurrent_versions (optional) }
      abort_incomplete_multipart_upload - { days_after_initiation }
    storage_class: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE or GLACIER_IR.
  EOT
  type = list(object({
    id      = string
    enabled = optional(bool, true)

    filter = optional(object({
      prefix                   = optional(string)
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      tag = optional(object({
        key   = string
        value = string
      }))
      and = optional(object({
        prefix                   = optional(string)
        tags                     = optional(map(string))
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
      }))
    }))

    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))

    transitions = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })), [])

    noncurrent_version_expiration = optional(object({
      noncurrent_days           = number
      newer_noncurrent_versions = optional(number)
    }))

    noncurrent_version_transitions = optional(list(object({
      noncurrent_days           = number
      newer_noncurrent_versions = optional(number)
      storage_class             = string
    })), [])

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))

  validation {
    condition     = length(var.rules) > 0
    error_message = "Defina ao menos uma regra (uma configuração vazia apagaria as regras existentes do bucket)."
  }

  validation {
    condition     = length(distinct([for r in var.rules : r.id])) == length(var.rules)
    error_message = "id precisa ser único entre as regras."
  }

  validation {
    condition     = alltrue([for r in var.rules : length(r.id) >= 1 && length(r.id) <= 255])
    error_message = "id precisa ter entre 1 e 255 caracteres."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.expiration != null ||
      length(r.transitions) > 0 ||
      r.noncurrent_version_expiration != null ||
      length(r.noncurrent_version_transitions) > 0 ||
      r.abort_incomplete_multipart_upload != null
    ])
    error_message = "Toda regra precisa de pelo menos uma ação: expiration, transitions, noncurrent_version_expiration, noncurrent_version_transitions ou abort_incomplete_multipart_upload."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.expiration == null ? true : (
        (r.expiration.date != null ? 1 : 0) +
        (r.expiration.days != null ? 1 : 0) +
        (r.expiration.expired_object_delete_marker != null ? 1 : 0) == 1
      )
    ])
    error_message = "expiration precisa definir exatamente um entre date, days ou expired_object_delete_marker."
  }

  validation {
    condition = alltrue([
      for r in var.rules : alltrue([
        for t in r.transitions : !(t.date != null && t.days != null)
      ])
    ])
    error_message = "Em transitions, use date ou days, não os dois."
  }

  validation {
    condition = alltrue([
      for r in var.rules : alltrue(concat(
        [for t in r.transitions : contains(["GLACIER", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "DEEP_ARCHIVE", "GLACIER_IR"], t.storage_class)],
        [for t in r.noncurrent_version_transitions : contains(["GLACIER", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "DEEP_ARCHIVE", "GLACIER_IR"], t.storage_class)],
      ))
    ])
    error_message = "storage_class precisa ser GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE ou GLACIER_IR."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.filter == null ? true : (
        (r.filter.prefix != null ? 1 : 0) +
        (r.filter.tag != null ? 1 : 0) +
        (r.filter.and != null ? 1 : 0) +
        (r.filter.object_size_greater_than != null ? 1 : 0) +
        (r.filter.object_size_less_than != null ? 1 : 0) <= 1
      )
    ])
    error_message = "filter aceita no máximo um entre prefix, tag, and, object_size_greater_than e object_size_less_than (use and para combinar)."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      try(r.filter.and, null) == null ? true : (
        (r.filter.and.prefix != null ? 1 : 0) +
        length(coalesce(r.filter.and.tags, {})) +
        (r.filter.and.object_size_greater_than != null ? 1 : 0) +
        (r.filter.and.object_size_less_than != null ? 1 : 0) >= 2
      )
    ])
    error_message = "filter.and precisa combinar dois ou mais predicados (prefix, tags, object_size_greater_than, object_size_less_than)."
  }
}
