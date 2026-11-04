# VPC Peering module

Creates a VPC peering connection and optionally manages the accepter side and
connection options.

## Example (Terragrunt)

```hcl
locals {
  env = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

dependency "vpc_requester" {
  config_path = "../../vpcs/requester"
}

dependency "vpc_accepter" {
  config_path = "../../vpcs/accepter"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/peering"
}

inputs = {
  vpc_id      = dependency.vpc_requester.outputs.id
  peer_vpc_id = dependency.vpc_accepter.outputs.id
  auto_accept = true

  requester = [
    { allow_remote_vpc_dns_resolution = true }
  ]

  accepter = [
    { allow_remote_vpc_dns_resolution = true }
  ]

  name = "example-peering"
  tags = {
    environment = local.env.environment
    component   = "vpc-peering"
  }
}
```

## Inputs

- `vpc_id` (string, required): Requester VPC ID.
- `peer_vpc_id` (string, required): Accepter VPC ID.
- `peer_owner_id` (string, optional): Accepter account ID (cross-account).
- `peer_region` (string, optional): Accepter region (inter-region).
- `auto_accept` (bool, optional): Accept peering automatically (same account/region).
- `accepter` (list(object), optional): Options for accepter side.
- `requester` (list(object), optional): Options for requester side.
- `manage_accepter` (bool, optional): Manage accepter side with `aws_vpc_peering_connection_accepter`.
- `manage_requester` (bool, optional, default `true`): Whether this unit creates the peering connection. Set to `false` on a cross-account accepter-only unit.
- `vpc_peering_connection_id` (string, optional): Required when `manage_requester = false` — ID of the connection created by the requester-side unit.
- `accepter_region` (string, optional): Region for accepter-side resources (`aws_vpc_peering_connection_accepter` and the accepter options resource), for a single provider managing multiple regions.
- `requester_region` (string, optional): Region for requester-side resources (`aws_vpc_peering_connection` and the requester options resource), symmetric with `accepter_region`.
- `manage_connection_options` (bool, optional): Manage options using `aws_vpc_peering_connection_options`.
- `accepter_auto_accept` (bool, optional): Auto-accept on accepter side.
- `name` (string, optional): Name tag value.
- `tags` (map(string), optional): Tags for peering resources.

## Outputs

- `id`: VPC peering connection ID.
- `accept_status`: Peering accept status.
- `accepter_id`: Accepter-side resource ID (if managed).
- `requester_options_id`: Requester options resource ID (if managed).
- `accepter_options_id`: Accepter options resource ID (if managed).

## Cross-account example (two accounts, two units)

A single AWS provider/credentials context can't create a peering connection
*and* accept it when the two VPCs belong to different accounts — the
requester and accepter must each run under their own account's provider.
Use two separate Terragrunt units, one per account:

Requester unit (account A):
```hcl
inputs = {
  vpc_id        = dependency.vpc.outputs.id
  peer_vpc_id   = "vpc-xxxxxxxx"      # accepter VPC ID, from account B
  peer_owner_id = "222222222222"       # account B's ID
  peer_region   = "us-east-1"          # only if inter-region
  auto_accept   = false                # required for cross-account/region
  manage_accepter = false              # accepter side is a separate unit in account B
}
```

Accepter unit (account B), applied after the requester unit so its `id`
output is known:
```hcl
inputs = {
  manage_requester           = false
  vpc_peering_connection_id  = "pcx-xxxxxxxx"  # `id` output of the requester unit
  manage_accepter             = true
  accepter_auto_accept        = true
  manage_connection_options   = true
  accepter = [
    { allow_remote_vpc_dns_resolution = true }
  ]
}
```

`vpc_peering_connection_id` can't be wired via a Terragrunt `dependency`
block across accounts unless the requester account's remote-state bucket
grants cross-account read — passing it as a literal input (copied from the
requester unit's `id` output after its apply) is the safe default.

## Notes

- For inter-region or same-account peering where a single provider covers
  both sides, set `auto_accept = false` and `manage_accepter = true` on one
  unit, with `accepter_region` for the accepter-side region.
- For cross-account peering, use `manage_requester = false` on the accepter
  unit (see above) — each side is applied independently.
- When `manage_connection_options = true`, this module uses
  `aws_vpc_peering_connection_options` and disables inline options on the main
  peering resource.
