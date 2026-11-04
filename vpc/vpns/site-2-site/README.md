# Site-to-Site VPN module

Creates a Site-to-Site VPN connection using a customer gateway and either a
VPN gateway (VGW) or a Transit Gateway (TGW).

## Example (Terraform)

```hcl
module "site_to_site_vpn" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/vpns/site-2-site"

  create_vpn_gateway = true
  vpc_id             = aws_vpc.main.id

  customer_gateway_ip      = "203.0.113.10"
  customer_gateway_bgp_asn = 65000

  static_routes_only = true
  static_routes      = ["10.10.0.0/16"]

  tags = {
    Name = "example-s2s"
  }
}
```

## Example (Terragrunt)

```hcl
terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//vpc/vpns/site-2-site"
}

inputs = {
  create_vpn_gateway = true
  vpc_id             = "vpc-xxxxxxxx"

  customer_gateway_ip      = "203.0.113.10"
  customer_gateway_bgp_asn = 65000

  static_routes_only = true
  static_routes      = ["10.10.0.0/16"]

  tags = {
    Name = "example-s2s"
  }
}
```

## Inputs

- `create_vpn_gateway` (bool, optional): Create a VPN gateway (VGW).
- `vpc_id` (string, optional): VPC ID for the VPN gateway when creating it.
- `vpn_gateway_id` (string, optional): Existing VPN gateway ID.
- `vpn_gateway_amazon_side_asn` (number, optional): Amazon side ASN for the VPN gateway.
- `transit_gateway_id` (string, optional): Transit Gateway ID.
- `customer_gateway_id` (string, optional): Existing customer gateway ID.
- `customer_gateway_ip` (string, optional): Customer gateway public IPv4 address.
- `customer_gateway_bgp_asn` (number, optional): Customer gateway BGP ASN.
- `customer_gateway_type` (string, optional): Customer gateway type (ipsec.1).
- `customer_gateway_device_name` (string, optional): Customer gateway device name.
- `vpn_connection_type` (string, optional): VPN connection type (ipsec.1).
- `static_routes_only` (bool, optional): Use static routes only.
- `static_routes` (list(string), optional): Static route destination CIDRs.
- `local_ipv4_network_cidr` (string, optional): IPv4 CIDR on the customer side.
- `remote_ipv4_network_cidr` (string, optional): IPv4 CIDR on the AWS side.
- `local_ipv6_network_cidr` (string, optional): IPv6 CIDR on the customer side.
- `remote_ipv6_network_cidr` (string, optional): IPv6 CIDR on the AWS side.
- `tunnel1_inside_cidr` (string, optional): Inside IPv4 CIDR for tunnel 1.
- `tunnel2_inside_cidr` (string, optional): Inside IPv4 CIDR for tunnel 2.
- `tunnel1_inside_ipv6_cidr` (string, optional): Inside IPv6 CIDR for tunnel 1.
- `tunnel2_inside_ipv6_cidr` (string, optional): Inside IPv6 CIDR for tunnel 2.
- `tunnel1_preshared_key` (string, optional): Preshared key for tunnel 1.
- `tunnel2_preshared_key` (string, optional): Preshared key for tunnel 2.
- `tunnel1_ike_versions` (list(string), optional): IKE versions for tunnel 1.
- `tunnel2_ike_versions` (list(string), optional): IKE versions for tunnel 2.
- `tags` (map(string), optional): Tags to apply to VPN resources.

## Outputs

- `vpn_connection_id`: VPN connection ID.
- `vpn_connection_arn`: VPN connection ARN.
- `customer_gateway_id`: Customer gateway ID.
- `vpn_gateway_id`: VPN gateway ID (null when using Transit Gateway).
- `transit_gateway_id`: Transit Gateway ID (null when using VPN gateway).
- `tunnel1_address`: Public IP address of tunnel 1.
- `tunnel2_address`: Public IP address of tunnel 2.
- `customer_gateway_configuration`: VPN configuration in XML.
