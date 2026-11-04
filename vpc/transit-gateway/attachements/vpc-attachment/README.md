# Transit Gateway VPC Attachment Module

Creates an EC2 Transit Gateway VPC attachment.

## Example (Terraform)

```hcl
module "tgw_attachment" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/transit-gateway/attachements/vpc-attachment"

  transit_gateway_id = aws_ec2_transit_gateway.example.id
  vpc_id             = aws_vpc.example.id
  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "example-tgw-attachment"
  }
}
```

## Example (Terragrunt)

```hcl
dependency "tgw" {
  config_path = "../transit-gateways/example"
}

dependency "vpc" {
  config_path = "../vpcs/example"
}

dependency "private_subnet_a" {
  config_path = "../subnets/example-private-a"
}

dependency "private_subnet_b" {
  config_path = "../subnets/example-private-b"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/transit-gateway/attachements/vpc-attachment"
}

inputs = {
  transit_gateway_id = dependency.tgw.outputs.id
  vpc_id             = dependency.vpc.outputs.id
  subnet_ids         = [
    dependency.private_subnet_a.outputs.id,
    dependency.private_subnet_b.outputs.id
  ]

  tags = {
    Name = "example-tgw-attachment"
  }
}
```

## Inputs

- `transit_gateway_id` (string, required): Transit Gateway ID.
- `vpc_id` (string, required): VPC ID.
- `subnet_ids` (list(string), required): Subnet IDs for the attachment.
- `dns_support` (string, optional): `enable` or `disable`.
- `ipv6_support` (string, optional): `enable` or `disable`.
- `appliance_mode_support` (string, optional): `enable` or `disable`.
- `security_group_referencing_support` (string, optional): `enable` or `disable`.
- `transit_gateway_default_route_table_association` (bool, optional): `true` or `false`.
- `transit_gateway_default_route_table_propagation` (bool, optional): `true` or `false`.
- `name` (string, optional): Name tag value.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: Attachment ID.
- `arn`: Attachment ARN.
- `transit_gateway_id`: Transit Gateway ID.
- `vpc_id`: VPC ID.
- `subnet_ids`: Subnet IDs used by the attachment.
- `tags_all`: All tags, including provider defaults.
- `vpc_owner_id`: AWS account ID that owns the VPC.
