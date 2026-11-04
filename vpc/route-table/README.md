# Route table module

Creates an AWS route table with routes and associations to subnets and gateways (IGW or VGW).

## Example (Terragrunt)

```hcl
terraform {
  source = "git::git@bitbucket.org:CIonline/opentofu-aws-modules.git//vpc/route-table"
}

inputs = {
  vpc_id = "vpc-xxxxxxxx"

  routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = "igw-xxxxxxxx"
    }
  ]

  subnet_associations = [
    "subnet-aaaaaaa",
    "subnet-bbbbbbb"
  ]

  gateway_associations = [
    "igw-xxxxxxxx"
  ]

  tags = {
    Name = "public-rt"
  }
}
```

## Inputs

- `vpc_id` (string, required): VPC ID.
- `routes` (list(object), optional): List of route objects.
- `subnet_associations` (list(string), optional): Subnet IDs to associate.
- `gateway_associations` (list(string), optional): Gateway IDs (IGW or VGW) to associate.
- `propagating_vgws` (list(string), optional): Virtual gateways for route propagation.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id` (string): Route table ID. Use it as `dependency.<route-table>.outputs.id` in Terragrunt (for example, in `route_table_ids` of a Gateway endpoint).

## Routes object keys

- `destination_cidr_block` (string, optional)
- `destination_ipv6_cidr_block` (string, optional)
- `destination_prefix_list_id` (string, optional)
- `carrier_gateway_id` (string, optional)
- `core_network_arn` (string, optional)
- `egress_only_gateway_id` (string, optional)
- `gateway_id` (string, optional)
- `local_gateway_id` (string, optional)
- `nat_gateway_id` (string, optional)
- `network_interface_id` (string, optional)
- `transit_gateway_id` (string, optional)
- `vpc_endpoint_id` (string, optional)
- `vpc_peering_connection_id` (string, optional)

## Notes

- Each route should set only one target (for example, `gateway_id` or `nat_gateway_id`).
- Subnet or gateway associations must be unique. If a subnet or gateway is already associated, import the existing association first.
