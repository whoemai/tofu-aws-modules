# Elastic IP Module

Creates an AWS Elastic IP (EIP) for use with resources like NAT Gateways or public instances.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Inputs

- `domain` (string, optional): Elastic IP domain. Use `vpc` for VPC EIPs or `standard` for EC2-Classic. Default: `null` (falls back to `vpc`).
- `vpc` (bool, optional, deprecated): Legacy flag to set the domain to `vpc` when true.
- `tags` (map(string), required): Tags to apply to the EIP.

## Outputs

- `id`: Elastic IP allocation ID.

## Terragrunt Examples

### ✅ VPC EIP (Recommended)

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/elastic-ip"
}

inputs = {
  domain = "vpc"

  tags = {
    Name        = "example-eip-${local.env.environment}"
    environment = local.env.environment
    component   = "elastic-ip"
  }
}
```

### ⚠️ Legacy Mode (Deprecated)

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/elastic-ip"
}

inputs = {
  vpc = true

  tags = {
    Name        = "example-eip-legacy-${local.env.environment}"
    environment = local.env.environment
    component   = "elastic-ip"
  }
}
```

## Notes

- Use `domain = "vpc"` for all modern VPC workloads.
- The `vpc` input is kept for backward compatibility and may be removed in a future version.
