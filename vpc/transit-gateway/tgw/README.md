# Transit Gateway module

Creates an AWS EC2 Transit Gateway and exposes resource arguments and outputs.

## Example (Terraform)

```hcl
module "tgw" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/transit-gateway/tgw"

  description = "core tgw"

  tags = {
    Name = "core-tgw"
  }
}
```

## Example (Terragrunt)

```hcl
terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/transit-gateway/tgw"
}

inputs = {
  description = "core tgw"

  tags = {
    Name = "core-tgw"
  }
}
```

## Inputs

All inputs are optional. When a value is null, the provider default applies.

- `description` (string, optional): Transit Gateway description.
- `amazon_side_asn` (string, optional): Amazon-side ASN for BGP.
- `auto_accept_shared_attachments` (string, optional): `enable` or `disable`.
- `default_route_table_association` (string, optional): `enable` or `disable`.
- `default_route_table_propagation` (string, optional): `enable` or `disable`.
- `dns_support` (string, optional): `enable` or `disable`.
- `vpn_ecmp_support` (string, optional): `enable` or `disable`.
- `multicast_support` (string, optional): `enable` or `disable`.
- `security_group_referencing_support` (string, optional): `enable` or `disable`.
- `encryption_support` (string, optional): `enable` or `disable`.
- `transit_gateway_cidr_blocks` (list(string), optional): One or more CIDR blocks.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: Transit Gateway ID.
- `arn`: Transit Gateway ARN.
- `association_default_route_table_id`: Default association route table ID.
- `propagation_default_route_table_id`: Default propagation route table ID.
- `owner_id`: AWS account ID that owns the Transit Gateway.
- `tags_all`: All tags, including provider defaults.
