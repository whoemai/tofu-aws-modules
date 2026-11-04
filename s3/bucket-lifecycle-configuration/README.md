# AWS S3 Bucket Lifecycle Configuration Module

OpenTofu module to manage the lifecycle configuration of an existing S3 bucket, covering every argument of the `aws_s3_bucket_lifecycle_configuration` resource.

## Table of Contents

- [AWS S3 Bucket Lifecycle Configuration Module](#aws-s3-bucket-lifecycle-configuration-module)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Minimal Terragrunt Example](#minimal-terragrunt-example)
    - [Terragrunt Example](#terragrunt-example)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Notes](#notes)

## Features

- Manages the lifecycle configuration of an existing bucket
- Multiple rules, each one can be disabled without being removed
- Filters by prefix, tag, object size, or a combination of them (`and`)
- Expiration of current versions by `date`, `days` or `expired_object_delete_marker`
- Transitions of current versions to `GLACIER`, `STANDARD_IA`, `ONEZONE_IA`, `INTELLIGENT_TIERING`, `DEEP_ARCHIVE` or `GLACIER_IR`
- Expiration and transition of noncurrent versions, including `newer_noncurrent_versions`
- Abort of incomplete multipart uploads
- Optional `transition_default_minimum_object_size`, `expected_bucket_owner` and `region`
- Validates unique rule IDs, at least one action per rule, conflicting arguments and storage classes

## Usage

### Minimal Terragrunt Example

Only the required inputs: the bucket and one rule with a single action. With no `filter`, the rule applies to the whole bucket.

```hcl
terraform {
  source = "[...]"
}

inputs = {
  bucket = "myorg-example-bucket"

  rules = [
    {
      id = "abort-incomplete-multipart"
      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    }
  ]
}
```

### Terragrunt Example

Complete example covering the filters and every action supported by the module.

```hcl
terraform {
  source = "[...]"
}

inputs = {
  bucket = "myorg-example-bucket"
  region = "us-east-1"

  transition_default_minimum_object_size = "varies_by_storage_class"

  rules = [
    {
      id = "abort-incomplete-multipart"
      abort_incomplete_multipart_upload = {
        days_after_initiation = 7
      }
    },
    {
      id     = "archive-and-expire-logs"
      filter = { prefix = "logs/" }

      transitions = [
        { days = 30, storage_class = "STANDARD_IA" },
        { days = 90, storage_class = "GLACIER" }
      ]

      expiration = { days = 365 }

      noncurrent_version_transitions = [
        { noncurrent_days = 30, storage_class = "GLACIER_IR" }
      ]

      noncurrent_version_expiration = {
        noncurrent_days           = 90
        newer_noncurrent_versions = 3
      }
    },
    {
      id         = "expire-short-retention-objects"
      filter     = { tag = { key = "Retention", value = "short" } }
      expiration = { days = 7 }
    },
    {
      id = "expire-large-tmp-objects"
      filter = {
        and = {
          prefix                   = "tmp/"
          tags                     = { Retention = "short" }
          object_size_greater_than = 1048576
        }
      }
      expiration = { days = 3 }
    },
    {
      id         = "clean-expired-delete-markers"
      expiration = { expired_object_delete_marker = true }
    },
    {
      id         = "expire-on-fixed-date"
      enabled    = false
      filter     = { object_size_less_than = 1024 }
      expiration = { date = "2030-01-01" }
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of an existing S3 bucket. | `string` | n/a | yes |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | (Deprecated by the provider) Account ID of the expected bucket owner. If the bucket is owned by a different account, the request fails with HTTP 403. Forces a new resource. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where this resource is managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Complete list of lifecycle rules for the bucket (this replaces any existing configuration), mirroring the aws\_s3\_bucket\_lifecycle\_configuration schema:<br>  id                                - unique rule identifier (max 255 characters)<br>  enabled                           - whether the rule is active (Enabled/Disabled)<br>  filter                            - objects the rule applies to; null applies to the whole bucket. Use at most one of prefix, tag, and, object\_size\_greater\_than, object\_size\_less\_than<br>    prefix                          - key prefix<br>    tag                             - single tag { key, value }<br>    object\_size\_greater\_than        - minimum object size in bytes<br>    object\_size\_less\_than           - maximum object size in bytes<br>    and                             - logical AND of two or more predicates: prefix, tags (map), object\_size\_greater\_than, object\_size\_less\_than<br>  expiration                        - current version expiration; set exactly one of date (RFC3339 full-date, e.g. 2023-08-22), days or expired\_object\_delete\_marker<br>  transitions                       - list of transitions of current versions { date or days, storage\_class }<br>  noncurrent\_version\_expiration     - { noncurrent\_days, newer\_noncurrent\_versions (optional) }<br>  noncurrent\_version\_transitions    - list of { noncurrent\_days, storage\_class, newer\_noncurrent\_versions (optional) }<br>  abort\_incomplete\_multipart\_upload - { days\_after\_initiation }<br>storage\_class: GLACIER, STANDARD\_IA, ONEZONE\_IA, INTELLIGENT\_TIERING, DEEP\_ARCHIVE or GLACIER\_IR. | <pre>list(object({<br>    id      = string<br>    enabled = optional(bool, true)<br><br>    filter = optional(object({<br>      prefix                   = optional(string)<br>      object_size_greater_than = optional(number)<br>      object_size_less_than    = optional(number)<br>      tag = optional(object({<br>        key   = string<br>        value = string<br>      }))<br>      and = optional(object({<br>        prefix                   = optional(string)<br>        tags                     = optional(map(string))<br>        object_size_greater_than = optional(number)<br>        object_size_less_than    = optional(number)<br>      }))<br>    }))<br><br>    expiration = optional(object({<br>      date                         = optional(string)<br>      days                         = optional(number)<br>      expired_object_delete_marker = optional(bool)<br>    }))<br><br>    transitions = optional(list(object({<br>      date          = optional(string)<br>      days          = optional(number)<br>      storage_class = string<br>    })), [])<br><br>    noncurrent_version_expiration = optional(object({<br>      noncurrent_days           = number<br>      newer_noncurrent_versions = optional(number)<br>    }))<br><br>    noncurrent_version_transitions = optional(list(object({<br>      noncurrent_days           = number<br>      newer_noncurrent_versions = optional(number)<br>      storage_class             = string<br>    })), [])<br><br>    abort_incomplete_multipart_upload = optional(object({<br>      days_after_initiation = number<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_transition_default_minimum_object_size"></a> [transition\_default\_minimum\_object\_size](#input\_transition\_default\_minimum\_object\_size) | Default minimum object size behavior applied to the lifecycle configuration: "all\_storage\_classes\_128K" (provider default) or "varies\_by\_storage\_class". Custom object\_size\_greater\_than / object\_size\_less\_than filters take precedence. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Bucket whose lifecycle configuration is managed. |
| <a name="output_rule_ids"></a> [rule\_ids](#output\_rule\_ids) | IDs of the lifecycle rules applied. |
<!-- END_TF_DOCS -->

## Notes

- The lifecycle configuration is replaced as a whole: any rule created manually (or by other IaC code) on the bucket is overwritten
- `filter = null` (the default) applies the rule to every object in the bucket
- Each rule needs at least one action: `expiration`, `transitions`, `noncurrent_version_expiration`, `noncurrent_version_transitions` or `abort_incomplete_multipart_upload`
- `expiration` takes exactly one of `date`, `days` or `expired_object_delete_marker`
- A `transitions` entry takes `date` or `days`; when neither is set the provider defaults to 0 days
- `filter` takes at most one of `prefix`, `tag`, `and`, `object_size_greater_than` or `object_size_less_than`; use `and` to combine predicates
- `id` must be unique across rules and have at most 255 characters
- `expected_bucket_owner` is deprecated by the provider
