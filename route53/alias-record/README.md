<!-- BEGIN_TF_DOCS -->
# route53/alias-record

Creates a single Route53 alias record (A or AAAA) pointing at an AWS-managed target
(CloudFront, ALB, S3 website endpoint, ...). Separate from `route53/record` because an
alias record has no `ttl`/`records` — those are mutually exclusive with the `alias`
block on `aws_route53_record`.

## Usage

```hcl
module "app_alias" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//route53/alias-record"

  zone_id = module.dns.zone_id
  name    = "app.${local.domain_name}"
  type    = "A"

  alias_target = {
    name    = module.cloudfront.domain_name
    zone_id = module.cloudfront.hosted_zone_id
  }
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
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | (Required) - The ID of the hosted zone to contain this record. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) - The name of the record. Accepts an FQDN or a name relative to the zone; "" is the zone apex. | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | (Optional) - A (IPv4) or AAAA (IPv6). One record per module instance. | `string` | `"A"` | no |
| <a name="input_alias_target"></a> [alias\_target](#input\_alias\_target) | (Required) - Alias target. For CloudFront: `name` = distribution `domain_name`, `zone_id` = distribution `hosted_zone_id` (`Z2FDTNDATAQYW2`, a global constant). | `object({name = string, zone_id = string, evaluate_target_health = optional(bool, false)})` | n/a | yes |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | (Optional) - Allow overwriting an existing record with the same name/type instead of failing on conflict. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The full name of the created record, including the trailing zone. |
| <a name="output_name"></a> [name](#output\_name) | The name of the record as stored by Route53. |

## Notes

- `evaluate_target_health = false` is right for a target with no health check of its own
  (CloudFront). Set it `true` for an ALB so Route53 stops answering the name once the
  whole target group is unhealthy.
- IPv6 on the same hostname is a second record (`type = "AAAA"`) — a second module
  instance, not a second value in this one.
<!-- END_TF_DOCS -->
