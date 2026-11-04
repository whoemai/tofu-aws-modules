<!-- BEGIN_TF_DOCS -->
# route53/vpc-association-authorization

Lado 1 (dono da zone) do handshake cross-account de associação de VPC com uma
Private Hosted Zone. Autoriza uma VPC de outra conta AWS a se associar à
zone — não faz a associação em si, isso é feito pela conta dona da VPC com
`route53/zone-association`, depois que esta autorização existir.

## Usage

```hcl
module "authorize_other_account_vpc" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//route53/vpc-association-authorization"

  zone_id = "Z1234567890ABCDEFGHI"
  vpc_id  = "vpc-0123456789abcdef0"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_vpc_association_authorization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_vpc_association_authorization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | (Required) - The ID of the private hosted zone to authorize the VPC association for. The zone must already exist in this account. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) - The ID of the VPC (in the OTHER account) being authorized to associate with the zone. | `string` | n/a | yes |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | (Optional) - The region of the VPC being authorized. Defaults to the provider's own region if omitted. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the hosted zone the authorization was created for. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC the authorization was created for. |

## Notes

- Run this in the account that owns the hosted zone, with a provider pointed at
  that account. The VPC being authorized lives in a different account —
  `vpc_id` is just a string reference, this module never touches that account.
- This resource alone does not make DNS resolve from the other account's VPC.
  Pair it with `route53/zone-association`, applied by the VPC-owning account,
  referencing the same `zone_id`/`vpc_id`.
- One authorization per VPC — associating N VPCs from another account needs N
  instances of this module.
- AWS's own recommendation: once the association (the other side) succeeds,
  delete this authorization. That does not undo the association, it only
  blocks re-associating without repeating the handshake — a cleanup step, not
  something this module enforces.
<!-- END_TF_DOCS -->
