resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket                                 = var.bucket
  expected_bucket_owner                  = var.expected_bucket_owner
  region                                 = var.region
  transition_default_minimum_object_size = var.transition_default_minimum_object_size

  dynamic "rule" {
    for_each = var.rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      # filter {} (sem argumentos) aplica a regra ao bucket inteiro.
      filter {
        prefix                   = try(rule.value.filter.prefix, null)
        object_size_greater_than = try(rule.value.filter.object_size_greater_than, null)
        object_size_less_than    = try(rule.value.filter.object_size_less_than, null)

        dynamic "tag" {
          for_each = try(rule.value.filter.tag, null) == null ? [] : [rule.value.filter.tag]
          content {
            key   = tag.value.key
            value = tag.value.value
          }
        }

        dynamic "and" {
          for_each = try(rule.value.filter.and, null) == null ? [] : [rule.value.filter.and]
          content {
            prefix                   = and.value.prefix
            tags                     = and.value.tags
            object_size_greater_than = and.value.object_size_greater_than
            object_size_less_than    = and.value.object_size_less_than
          }
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration == null ? [] : [rule.value.expiration]
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration == null ? [] : [rule.value.noncurrent_version_expiration]
        content {
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload == null ? [] : [rule.value.abort_incomplete_multipart_upload]
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}
