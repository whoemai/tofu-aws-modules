# NAT Gateway Module

Creates an AWS NAT Gateway with support for zonal (single-AZ) and regional (multi-AZ) modes, plus public or private connectivity.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
resource "aws_eip" "nat" {
  domain = "vpc"
}

module "nat_gateway" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/nat-gateway"

  allocation_id     = aws_eip.nat.id
  subnet_id         = aws_subnet.public.id
  connectivity_type = "public"
  availability_mode = "zonal"

  tags = {
    Name = "example-nat"
  }
}
```

## Terragrunt Examples

### Public Zonal NAT Gateway

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

dependency "eip" {
  config_path = "../../eips/example-nat"
}

dependency "public_subnet" {
  config_path = "../../subnets/public-a"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/nat-gateway"
}

inputs = {
  allocation_id = dependency.eip.outputs.id
  subnet_id     = dependency.public_subnet.outputs.id

  tags = {
    Name        = "example-nat-${local.env.environment}"
    environment = local.env.environment
    component   = "nat-gateway"
  }
}
```

### Private Zonal NAT Gateway

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

dependency "private_subnet" {
  config_path = "../../subnets/private-a"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/nat-gateway"
}

inputs = {
  connectivity_type = "private"
  subnet_id         = dependency.private_subnet.outputs.id

  tags = {
    Name        = "example-nat-private-${local.env.environment}"
    environment = local.env.environment
    component   = "nat-gateway"
  }
}
```

### Regional NAT Gateway (Manual Mode)

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

dependency "vpc" {
  config_path = "../../vpcs/example"
}

dependency "eip_a" {
  config_path = "../../eips/nat-a"
}

dependency "eip_b" {
  config_path = "../../eips/nat-b"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/nat-gateway"
}

inputs = {
  availability_mode = "regional"
  connectivity_type = "public"
  vpc_id            = dependency.vpc.outputs.id

  availability_zone_address = [
    {
      allocation_ids    = [dependency.eip_a.outputs.id]
      availability_zone = "us-east-1a"
    },
    {
      allocation_ids    = [dependency.eip_b.outputs.id]
      availability_zone = "us-east-1b"
    }
  ]

  tags = {
    Name        = "example-nat-regional-${local.env.environment}"
    environment = local.env.environment
    component   = "nat-gateway"
  }
}
```

## Inputs

- `allocation_id` (string, optional): EIP allocation ID for public zonal NAT gateways.
- `connectivity_type` (string, optional): `public` or `private`. Default: `public`.
- `availability_mode` (string, optional): `zonal` or `regional`. Default: `zonal`.
- `subnet_id` (string, optional): Required for `zonal` NAT. Must be null for `regional`.
- `vpc_id` (string, optional): Required for `regional` NAT. Must be null for `zonal`.
- `availability_zone_address` (list(object), optional): Manual configuration for regional NAT. Each item has:
  - `allocation_ids` (list(string), required)
  - `availability_zone` (string, optional)
  - `availability_zone_id` (string, optional)
- `private_ip` (string, optional): Private IPv4 address for the NAT gateway.
- `secondary_allocation_ids` (list(string), optional): Secondary EIP allocations (zonal only).
- `secondary_private_ip_addresses` (list(string), optional): Secondary private IPs (zonal only).
- `secondary_private_ip_address_count` (number, optional): Count of secondary private IPs.
- `tags` (map(string), required): Resource tags.
- `validate_public_allocation_id` (bool, optional): Validate allocation requirements. Default: `true`.
- `validate_nat_gateway_mode` (bool, optional): Validate zonal/regional requirements. Default: `true`.

## Outputs

- `id`: NAT Gateway ID.
- `public_ip`: Public IP for a public, zonal NAT gateway.
- `network_interface_id`: Network interface ID for a zonal NAT gateway.
- `association_id`: EIP association ID for a public, zonal NAT gateway.
- `route_table_id`: Route table ID for a regional NAT gateway.
- `regional_nat_gateway_address`: Regional NAT gateway address blocks.
- `auto_provision_zones`: Whether AWS auto-manages AZ coverage for regional NAT gateways.
- `auto_scaling_ips`: Whether AWS auto-allocates extra EIPs for regional NAT gateways.

## Notes

- Regional NAT requires `availability_mode = "regional"`, `connectivity_type = "public"`, and `vpc_id`.
- Zonal NAT requires `subnet_id`. For public zonal NAT, `allocation_id` is required.
- Do not use `secondary_allocation_ids` together with `aws_nat_gateway_eip_association`.
- For public NAT gateways, ensure an Internet Gateway is attached to the VPC before creation.
