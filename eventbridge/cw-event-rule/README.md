# EventBridge rule module

Creates an `aws_cloudwatch_event_rule`. It takes either an `event_pattern` (reacts to events) or a `schedule_expression` (cron/rate), and exports the rule `id` so a target can be attached with the `eventbridge/cw-event-target` module.

## Example (Terragrunt)

Rule that reacts to AWS Health events:

```hcl
terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//eventbridge/cw-event-rule"
}

inputs = {
  name        = "eks-projeto-karpenter-health"
  description = "Karpenter (eks-projeto): AWS Health events -> interruption queue"

  event_pattern = jsonencode({
    source      = ["aws.health"]
    detail-type = ["AWS Health Event"]
  })

  tags = {
    Name        = "eks-projeto-karpenter-health"
    environment = "projeto"
    component   = "eventbridge-cw-event-rule"
  }
}
```

Rule on a schedule (use `schedule_expression` instead of `event_pattern`):

```hcl
inputs = {
  name                = "nightly-cleanup"
  description         = "Runs every day at 03:00 UTC"
  schedule_expression = "cron(0 3 * * ? *)"
}
```

Attaching a target to the rule (module `eventbridge/cw-event-target`), using the `id` output:

```hcl
dependency "rule" {
  config_path = "../../cw-event-rule/eks-projeto-karpenter-health"

  mock_outputs                            = { id = "mock-rule" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
}

inputs = {
  rule = dependency.rule.outputs.id
  # ...
}
```

## Inputs

- `name` (string, required): Rule name.
- `description` (string, required): Rule description.
- `event_pattern` (string, optional): Event pattern as a JSON string. At least one of `event_pattern` or `schedule_expression` is required.
- `schedule_expression` (string, optional): Schedule expression (`cron(...)` or `rate(...)`).
- `tags` (map(string), optional): Resource tags. Default `{}`.

## Outputs

- `id` (string): Rule ID (its name). Use it as `dependency.<rule>.outputs.id` in Terragrunt, for example in the `rule` input of `cw-event-target`.
- `arn` (string): Rule ARN.

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.aer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of resource | `string` | n/a | yes |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | (Optional) The event pattern described a JSON object. At least one of schedule\_expression or event\_pattern is required. See full documentation of Events and Event Patterns in EventBridge for details. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with name\_prefix. | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | (Optional) The event pattern described a JSON object. At least one of schedule\_expression or event\_pattern is required. See full documentation of Events and Event Patterns in EventBridge for details. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->
