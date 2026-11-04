# Subnet module

Creates an AWS subnet with optional IPv6, DNS, IPAM, and Outposts settings. All non-required settings are optional to keep the module agnostic to subnet types.

## Example (Terraform)

```hcl
module "subnet_public" {
  source = "git::git@bitbucket.org:CIonline/opentofu-aws-modules.git//vpc/subnet"

  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1a"
  }
}
```

## Example (Terragrunt)

```hcl
terraform {
  source = "git::git@bitbucket.org:CIonline/opentofu-aws-modules.git//vpc/subnet"
}

inputs = {
  vpc_id                  = "vpc-xxxxxxxx"
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1b"
  }
}
```

## Inputs

- `vpc_id` (string, required): VPC ID.
- `cidr_block` (string, optional): IPv4 CIDR block for the subnet.
- `availability_zone` (string, optional): Availability Zone name.
- `availability_zone_id` (string, optional): Availability Zone ID.
- `map_public_ip_on_launch` (bool, optional): Assign public IPs on launch. Default: `false`.
- `assign_ipv6_address_on_creation` (bool, optional): Assign IPv6 addresses on ENI creation. Default: `false`.
- `ipv6_cidr_block` (string, optional): IPv6 CIDR block (must be /64).
- `ipv6_native` (bool, optional): Create IPv6-only subnet. Default: `false`.
- `enable_dns64` (bool, optional): Enable DNS64. Default: `false`.
- `enable_resource_name_dns_a_record_on_launch` (bool, optional): Enable DNS A records for instance hostnames. Default: `false`.
- `enable_resource_name_dns_aaaa_record_on_launch` (bool, optional): Enable DNS AAAA records for instance hostnames. Default: `false`.
- `private_dns_hostname_type_on_launch` (string, optional): `ip-name` or `resource-name`.
- `ipv4_ipam_pool_id` (string, optional): IPv4 IPAM pool ID.
- `ipv4_netmask_length` (number, optional): IPv4 netmask length for IPAM.
- `ipv6_ipam_pool_id` (string, optional): IPv6 IPAM pool ID.
- `ipv6_netmask_length` (number, optional): IPv6 netmask length for IPAM.
- `outpost_arn` (string, optional): Outpost ARN.
- `customer_owned_ipv4_pool` (string, optional): Customer owned IPv4 pool.
- `map_customer_owned_ip_on_launch` (bool, optional): Assign customer owned IPs on launch. Default: `false`.
- `enable_lni_at_device_index` (number, optional): Device index for local network interfaces.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: Subnet ID.
- `cidr_block`: Subnet CIDR block.

## Notes

- For IPAM-managed subnets, omit `cidr_block` and set `ipv4_ipam_pool_id` and `ipv4_netmask_length` (or the IPv6 equivalents).
