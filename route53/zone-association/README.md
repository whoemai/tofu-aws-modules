<!-- BEGIN_TF_DOCS -->
# route53/zone-association

Lado 2 (dono da VPC) do handshake cross-account de associação de VPC com uma
Private Hosted Zone. Associa de fato a VPC à zone de outra conta — só
funciona depois que a conta dona da zone já tiver criado a autorização com
`route53/vpc-association-authorization` pro mesmo par `zone_id`/`vpc_id`.

## Usage

```hcl
module "associate_our_vpc" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//route53/zone-association"

  zone_id = "Z1234567890ABCDEFGHI" # zone da outra conta, autorização já criada lá
  vpc_id  = "vpc-0123456789abcdef0" # nossa própria VPC
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
| [aws_route53_zone_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | (Required) - The ID of the private hosted zone (owned by another account) to associate this VPC with. A prior authorization must already exist. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) - The ID of the VPC (in this account) to associate with the zone. | `string` | n/a | yes |
| <a name="input_vpc_region"></a> [vpc\_region](#input\_vpc\_region) | (Optional) - The region of the VPC. Defaults to the provider's own region if omitted. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the hosted zone the VPC was associated with. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC that was associated. |
| <a name="output_owning_account"></a> [owning\_account](#output\_owning\_account) | The account ID that owns the hosted zone. |

## Notes

- Run this in the account that owns the VPC, with a provider pointed at that
  account. The zone lives in a different account — `zone_id` is just a string
  reference, this module never touches that account.
- Applying this before the authorization exists on the other side fails with
  `AccessDenied` — real behavior confirmed in the AWS provider's own resource
  source, not assumed. Order matters: authorization first, association
  second.
- Once this association is created, the zone-owning account can (optionally,
  AWS's own recommendation) delete its authorization — that does not undo
  this association.
<!-- END_TF_DOCS -->
