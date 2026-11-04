variable "region" {
  type        = string
  default     = null
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "bucket" {
  type        = string
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to allow deleting non-empty buckets."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The resource Tags"
}

variable "acl" {
  type        = string
  default     = "private"
  description = "(Optional, Conflicts with access_control_policy) The canned ACL to apply to the bucket."
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable bucket versioning."
}

variable "status" {
  type        = string
  default     = "Suspended"
  description = "S3 Transfer Acceleration status (Enabled or Suspended). Set to \"Enabled\" when a client always requests the accelerate endpoint — otherwise S3 returns InvalidRequest (\"S3 Transfer Acceleration is not configured on this bucket\")."

  validation {
    condition     = contains(["Enabled", "Suspended"], var.status)
    error_message = "status must be either Enabled or Suspended."
  }
}

variable "cors_rules" {
  type = list(object({
    id              = optional(string)
    allowed_headers = optional(list(string), [])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number)
  }))
  default     = []
  description = "CORS rules for the bucket. Empty list (default) creates no CORS configuration. Required when a browser talks to the bucket directly (e.g. presigned PUT from a web app) — without it the preflight OPTIONS gets no Access-Control-Allow-Origin and the browser blocks the request."

  validation {
    condition = alltrue([
      for r in var.cors_rules : alltrue([for m in r.allowed_methods : contains(["GET", "PUT", "POST", "DELETE", "HEAD"], m)])
    ])
    error_message = "cors_rules[*].allowed_methods only accepts GET, PUT, POST, DELETE or HEAD."
  }
}

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether to block public ACLs."
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Whether to block public bucket policies."
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Whether to ignore public ACLs."
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Whether to restrict public bucket policies."
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "Server-side encryption algorithm (AES256 or aws:kms)."

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm must be either AES256 or aws:kms."
  }
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ARN or ID for aws:kms encryption."
}

variable "bucket_key_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable bucket key for SSE-KMS."
}

variable "enforce_tls" {
  type        = bool
  default     = true
  description = "Whether to deny non-TLS requests via bucket policy."
}

variable "enforce_sse" {
  type        = bool
  default     = true
  description = "Whether to deny uploads without the expected SSE header via bucket policy."
}

variable "expiration_days" {
  type        = number
  default     = null
  description = "Days until an object expires. null (default) disables the rule entirely — for write-heavy buckets that would otherwise accumulate objects forever. Lives in the same aws_s3_bucket_lifecycle_configuration as the abort-incomplete-multipart rule, so it only takes effect while enable_lifecycle_rules is true."

  validation {
    condition     = var.expiration_days == null || var.expiration_days >= 1
    error_message = "expiration_days must be null or at least 1."
  }
}

variable "enable_expiration" {
  type        = bool
  default     = true
  description = "Whether the expire-objects rule is active. Only relevant while expiration_days is set — lets you pause expiration without discarding the configured day count, same pattern as enable_abort_incomplete_multipart_upload."
}

variable "policy" {
  type        = string
  default     = null
  description = "Additional bucket policy JSON to merge with baseline policy."
}

variable "logging_target_bucket" {
  type        = string
  default     = null
  description = "Target bucket for access logs."
}

variable "logging_target_prefix" {
  type        = string
  default     = null
  description = "Prefix for access logs in the target bucket."
}

variable "enable_lifecycle_rules" {
  type        = bool
  default     = true
  description = "Whether to enable lifecycle rules."
}

variable "enable_abort_incomplete_multipart_upload" {
  type        = bool
  default     = true
  description = "Whether to abort incomplete multipart uploads."
}

variable "abort_incomplete_multipart_upload_days" {
  type        = number
  default     = 7
  description = "Days to wait before aborting incomplete multipart uploads."

  validation {
    condition     = var.abort_incomplete_multipart_upload_days >= 1
    error_message = "abort_incomplete_multipart_upload_days must be at least 1."
  }
}

variable "noncurrent_version_expiration_days" {
  type        = number
  default     = null
  description = "Days after which noncurrent versions of objects are permanently removed. null (default) disables the rule entirely — useful on versioned buckets whose real retention is controlled by the writing application rather than by S3 itself, so a deleted object's prior version doesn't keep being billed forever. Lives in the same aws_s3_bucket_lifecycle_configuration as the other lifecycle rules, so it only takes effect while enable_lifecycle_rules is true."

  validation {
    condition     = var.noncurrent_version_expiration_days == null || var.noncurrent_version_expiration_days >= 1
    error_message = "noncurrent_version_expiration_days must be null or at least 1."
  }
}

variable "enable_noncurrent_version_expiration" {
  type        = bool
  default     = true
  description = "Whether the expire-noncurrent-versions rule is active. Only relevant while noncurrent_version_expiration_days is set — lets you pause it without discarding the configured day count, same pattern as enable_expiration."
}

variable "object_ownership" {
  type        = string
  default     = "BucketOwnerPreferred"
  description = "Object ownership setting. Use 'BucketOwnerEnforced' to disable ACLs entirely (recommended by AWS); in that case, 'acl' is ignored."

  validation {
    condition     = contains(["BucketOwnerPreferred", "BucketOwnerEnforced", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be one of: BucketOwnerPreferred, BucketOwnerEnforced, ObjectWriter."
  }
}
