# EBS Encryption By Default Module

Enables EBS encryption by default for a region — every new EBS volume and snapshot copy is encrypted automatically, without needing per-resource configuration (e.g. no need for a custom launch template just to set `encrypted = true`).

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "ebs_encryption_by_default" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//ec2/ebs-encryption-by-default"
}
```

## Terragrunt Example

```hcl
terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//ec2/ebs-encryption-by-default"
}

inputs = {
  enabled = true
}
```

## Inputs

- `enabled` (bool, optional, default `true`): whether EBS encryption by default is enabled for the region the provider is configured for.

## Outputs

- `enabled`: current state of EBS encryption by default in the region.

## Notes

- This is a region-level, account-wide setting (`aws_ebs_encryption_by_default`) — it is not scoped to a single resource. Only one instance of this module should be applied per (account, region) pair.
- Uses the AWS managed key `aws/ebs` unless the account's default EBS KMS key has been changed separately (`aws_ebs_default_kms_key`, not covered by this module).
