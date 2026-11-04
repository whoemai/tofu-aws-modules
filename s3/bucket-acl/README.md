# S3 Bucket Module with ACL Support

This Terraform/OpenTofu module creates an S3 bucket with comprehensive security features including versioning, encryption, public access blocking, logging, lifecycle rules, and baseline security policies.

## Table of Contents

- [S3 Bucket Module with ACL Support](#s3-bucket-module-with-acl-support)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Terraform Example](#terraform-example)
    - [Terragrunt Example](#terragrunt-example)
  - [Security Best Practices](#security-best-practices)
    - [Access Logs Bucket Configuration](#access-logs-bucket-configuration)
    - [Custom KMS Key](#custom-kms-key)
  - [Module Reference](#module-reference)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

## Features

- S3 bucket with customizable ACL support
- Configurable object ownership (`BucketOwnerPreferred`, `BucketOwnerEnforced`, or `ObjectWriter`) — set `object_ownership = "BucketOwnerEnforced"` to disable ACLs entirely, per AWS's current recommendation for new buckets
- Server-side encryption (SSE-S3 or SSE-KMS)
- Versioning control
- S3 Transfer Acceleration control (`status = "Enabled"` or `"Suspended"`, default `"Suspended"`)
- CORS rules (`cors_rules`, default `[]` = no CORS configuration) — needed when a browser uploads/downloads directly, e.g. presigned PUT
- Public access blocking
- Access logging to target bucket
- Lifecycle rules for incomplete multipart uploads and, optionally, object expiration (`expiration_days`)
- Lifecycle rule for noncurrent version expiration on versioned buckets (`noncurrent_version_expiration_days`) — for buckets whose real retention is controlled by the writing application, not by S3 itself
- Baseline security policies:
  - Enforce TLS/HTTPS connections
  - Enforce server-side encryption on uploads
- Custom bucket policy merging

## Usage

### Terraform Example

```hcl
module "lambda_artifacts_bucket" {
  source = "[...]"

  bucket        = "acme-prod-lambda-artifacts"
  acl           = "private"
  force_destroy = false

  versioning_enabled = true

  # Transfer acceleration status (Enabled/Suspended; only "Enabled" if the client always requests the accelerate endpoint)
  status = "Suspended"

  # Public access blocking
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Encryption with AWS-managed KMS key
  sse_algorithm      = "aws:kms"
  kms_key_id         = "alias/aws/s3"
  bucket_key_enabled = true

  # Security policies
  enforce_tls = true
  enforce_sse = true

  # Access logging
  logging_target_bucket = "acme-prod-access-logs"
  logging_target_prefix = "lambda-artifacts/"

  # Lifecycle rules
  enable_lifecycle_rules                   = true
  enable_abort_incomplete_multipart_upload = true
  abort_incomplete_multipart_upload_days   = 7

  # Object expiration (null = disabled, the default)
  expiration_days = 30

  # Noncurrent version expiration on versioned buckets (null = disabled, the
  # default) — for buckets where the application, not S3, decides retention
  noncurrent_version_expiration_days = 30

  tags = {
    Environment = "production"
    Project     = "lambda-deployment"
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

output "bucket_name" {
  value = module.lambda_artifacts_bucket.bucket
}

output "bucket_arn" {
  value = module.lambda_artifacts_bucket.bucket_arn
}
```

### Terragrunt Example

**Directory structure:**
```
infrastructure/
|-- environments/
|   `-- production/
|       `-- us-east-1/
|           `-- s3/
|               |-- access-logs/
|               |   `-- terragrunt.hcl
|               `-- lambda-artifacts/
|                   `-- terragrunt.hcl
```

**File: `access-logs/terragrunt.hcl`**
```hcl
locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
  project  = "lambda-deployment"
}

terraform {
  source = "[...]"
}

inputs = {
  bucket        = "acme-prod-access-logs"
  acl           = "log-delivery-write"
  force_destroy = false

  versioning_enabled = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # SSE-S3 for log delivery compatibility
  sse_algorithm      = "AES256"
  kms_key_id         = null
  bucket_key_enabled = false

  enforce_tls = true
  enforce_sse = false

  # No self-logging
  logging_target_bucket = null
  logging_target_prefix = null

  enable_lifecycle_rules                   = true
  enable_abort_incomplete_multipart_upload = true
  abort_incomplete_multipart_upload_days   = 7

  tags = {
    environment = local.env_vars.environment
    project     = local.project
    managed-by  = "terragrunt"
    component   = "access-logs"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
```

---

## Security Best Practices

### Object Ownership and ACLs

AWS now recommends disabling ACLs entirely for new buckets by setting object ownership to `BucketOwnerEnforced`. When this is set, the `acl` variable has no effect (the `aws_s3_bucket_acl` resource is not created), because the S3 API rejects `PutBucketAcl` calls while ACLs are disabled.

```hcl
object_ownership = "BucketOwnerEnforced"
```

Use `BucketOwnerPreferred` (the default) only when the bucket genuinely needs ACLs — for example, an access-logs bucket that must grant the S3 log delivery service write access via `acl = "log-delivery-write"`.

### Access Logs Bucket Configuration

When creating a bucket for S3 access logs:

- Use `acl = "log-delivery-write"` to allow S3 log delivery service
- Use `sse_algorithm = "AES256"` (SSE-S3) - SSE-KMS is not supported for log delivery
- Set `enforce_sse = false` to prevent blocking log delivery
- Set `logging_target_bucket = null` to avoid recursive logging

### Custom KMS Key

To use a customer-managed KMS key:

```hcl
sse_algorithm = "aws:kms"
kms_key_id    = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-ab12-cd34-ef56-abcdef123456"
```
---

## Module Reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.asb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.asbac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.asba](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource (only created when `object_ownership != "BucketOwnerEnforced"`) |
| [aws_s3_bucket_cors_configuration.asbcc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource (only created when `cors_rules` is not empty) |
| [aws_s3_bucket_lifecycle_configuration.asblc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.asbl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_ownership_controls.asboc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.asbp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.asbpab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.asbsec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.asbv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.baseline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | (Optional, Conflicts with access\_control\_policy) The canned ACL to apply to the bucket. | `string` | `"private"` | no |
| <a name="input_abort_incomplete_multipart_upload_days"></a> [abort_incomplete_multipart_upload_days](#input\_abort_incomplete_multipart_upload_days) | Days to wait before aborting incomplete multipart uploads. | `number` | `7` | no |
| <a name="input_block_public_acls"></a> [block_public_acls](#input\_block_public_acls) | Whether to block public ACLs. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block_public_policy](#input\_block_public_policy) | Whether to block public bucket policies. | `bool` | `true` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | (Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. | `string` | n/a | yes |
| <a name="input_bucket_key_enabled"></a> [bucket_key_enabled](#input\_bucket_key_enabled) | Whether to enable bucket key for SSE-KMS. | `bool` | `true` | no |
| <a name="input_cors_rules"></a> [cors_rules](#input\_cors_rules) | CORS rules for the bucket. Empty list (default) creates no CORS configuration. | `list(object({ id, allowed_headers, allowed_methods, allowed_origins, expose_headers, max_age_seconds }))` | `[]` | no |
| <a name="input_enable_abort_incomplete_multipart_upload"></a> [enable_abort_incomplete_multipart_upload](#input\_enable_abort_incomplete_multipart_upload) | Whether to abort incomplete multipart uploads. | `bool` | `true` | no |
| <a name="input_enable_expiration"></a> [enable_expiration](#input\_enable_expiration) | Whether the expire-objects rule is active. Only relevant while expiration_days is set. | `bool` | `true` | no |
| <a name="input_enable_lifecycle_rules"></a> [enable_lifecycle_rules](#input\_enable_lifecycle_rules) | Whether to enable lifecycle rules. | `bool` | `true` | no |
| <a name="input_enable_noncurrent_version_expiration"></a> [enable_noncurrent_version_expiration](#input\_enable_noncurrent_version_expiration) | Whether the expire-noncurrent-versions rule is active. Only relevant while noncurrent_version_expiration_days is set. | `bool` | `true` | no |
| <a name="input_enforce_sse"></a> [enforce_sse](#input\_enforce_sse) | Whether to deny uploads without the expected SSE header via bucket policy. | `bool` | `true` | no |
| <a name="input_enforce_tls"></a> [enforce_tls](#input\_enforce_tls) | Whether to deny non-TLS requests via bucket policy. | `bool` | `true` | no |
| <a name="input_expiration_days"></a> [expiration_days](#input\_expiration_days) | Days until an object expires. null (default) disables the rule. | `number` | `null` | no |
| <a name="input_force_destroy"></a> [force_destroy](#input\_force_destroy) | Whether to allow deleting non-empty buckets. | `bool` | `false` | no |
| <a name="input_ignore_public_acls"></a> [ignore_public_acls](#input\_ignore_public_acls) | Whether to ignore public ACLs. | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms_key_id](#input\_kms_key_id) | KMS key ARN or ID for aws:kms encryption. | `string` | `null` | no |
| <a name="input_logging_target_bucket"></a> [logging_target_bucket](#input\_logging_target_bucket) | Target bucket for access logs. | `string` | `null` | no |
| <a name="input_logging_target_prefix"></a> [logging_target_prefix](#input\_logging_target_prefix) | Prefix for access logs in the target bucket. | `string` | `null` | no |
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent_version_expiration_days](#input\_noncurrent_version_expiration_days) | Days after which noncurrent versions of objects are permanently removed. null (default) disables the rule. | `number` | `null` | no |
| <a name="input_object_ownership"></a> [object_ownership](#input\_object_ownership) | Object ownership setting. Use `"BucketOwnerEnforced"` to disable ACLs entirely (recommended by AWS); in that case, `acl` is ignored. One of `BucketOwnerPreferred`, `BucketOwnerEnforced`, `ObjectWriter`. | `string` | `"BucketOwnerPreferred"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | Additional bucket policy JSON to merge with baseline policy. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict_public_buckets](#input\_restrict_public_buckets) | Whether to restrict public bucket policies. | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse_algorithm](#input\_sse_algorithm) | Server-side encryption algorithm (AES256 or aws:kms). | `string` | `"AES256"` | no |
| <a name="input_status"></a> [status](#input\_status) | S3 Transfer Acceleration status (Enabled or Suspended). Set to "Enabled" when a client always requests the accelerate endpoint — otherwise S3 returns InvalidRequest ("S3 Transfer Acceleration is not configured on this bucket"). | `string` | `"Suspended"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The resource Tags | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input\_versioning_enabled) | Whether to enable bucket versioning. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Name of Bucket |
| <a name="output_bucket_arn"></a> [bucket_arn](#output\_bucket_arn) | Bucket ARN |
| <a name="output_bucket_id"></a> [bucket_id](#output\_bucket_id) | Bucket ID |
<!-- END_TF_DOCS -->