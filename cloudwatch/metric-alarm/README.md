# CloudWatch Metric Alarm Module

Creates a single-metric CloudWatch alarm. The metric, its dimensions and the comparison are all
inputs, so the same module serves any namespace. Metric math (`metric_query`), anomaly detection and
PromQL alarms (`evaluation_criteria`) are not exposed, since they change which of the arguments below
are required.

`namespace`, `metric_name` and `dimensions` are what vary per service. Take them from the emitting
service's CloudWatch documentation: a dimension set that the service does not publish leaves the
alarm in `INSUFFICIENT_DATA` rather than failing.

## Usage

### Terragrunt

```hcl
locals {
  tag_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl")).locals
}

dependency "nlb" {
  config_path = "../../../ec2/loadbalancer/my-nlb"

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    arn_suffix                = "net/mock/0000000000000000"
    target_group_arn_suffixes = { "my-listener" = "targetgroup/mock/0000000000000000" }
  }
}

terraform {
  source = "git::https://your-git-platform.com//opentofu-aws-modules.git//cloudwatch/metric-alarm?ref=<tag>"
}

inputs = {
  alarm_name          = "my-nlb-no-healthy-targets-${local.tag_vars.environment}"
  alarm_description   = "my-nlb has no healthy target registered."
  namespace           = "AWS/NetworkELB"
  metric_name         = "HealthyHostCount"
  statistic           = "Maximum"
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  period              = 300
  evaluation_periods  = 2

  # The metric stops being published when no target is registered, so an empty
  # target group would otherwise read as "no data" instead of a problem.
  treat_missing_data = "breaching"

  # AWS/NetworkELB publishes this metric against both dimensions together, as
  # ARN suffixes. A full ARN, or either dimension alone, matches nothing.
  dimensions = {
    LoadBalancer = dependency.nlb.outputs.arn_suffix
    TargetGroup  = dependency.nlb.outputs.target_group_arn_suffixes["my-listener"]
  }

  # SNS topic ARNs to notify. Empty means the alarm is visible in CloudWatch
  # but notifies nobody.
  alarm_actions = []

  tags = {
    region      = local.tag_vars.region
    environment = local.tag_vars.environment
    cost-type   = local.tag_vars.cost-type
    cost-center = local.tag_vars.cost-center
    team        = local.tag_vars.team
    owner       = local.tag_vars.owner
    managed-by  = local.tag_vars.managed-by
    component   = "cloudwatch-metric-alarm"
    project     = "my-project"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
```

Confirm the alarm is reading a series that exists before trusting it — an empty `Datapoints` list
means the dimension combination is wrong:

```bash
aws cloudwatch get-metric-statistics --namespace AWS/NetworkELB \
  --metric-name HealthyHostCount --statistics Maximum --period 300 \
  --dimensions Name=LoadBalancer,Value=net/my-nlb/0123456789abcdef \
               Name=TargetGroup,Value=targetgroup/my-listener/0123456789abcdef \
  --start-time 2026-01-01T00:00:00Z --end-time 2026-01-01T01:00:00Z
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_actions_enabled"></a> [actions\_enabled](#input\_actions\_enabled) | (Optional) Whether actions are executed on state changes. Null leaves the provider default (`true`). | `bool` | `null` | no |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | (Optional) ARNs to execute when the alarm transitions to ALARM. | `list(string)` | `[]` | no |
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | (Optional) Description of the alarm. | `string` | `null` | no |
| <a name="input_alarm_name"></a> [alarm\_name](#input\_alarm\_name) | (Required) Descriptive name for the alarm. Must be unique within the AWS account. | `string` | n/a | yes |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | (Required) Arithmetic operation used when comparing the statistic and the threshold. One of GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, GreaterThanUpperThreshold. | `string` | n/a | yes |
| <a name="input_datapoints_to_alarm"></a> [datapoints\_to\_alarm](#input\_datapoints\_to\_alarm) | (Optional) Number of datapoints that must be breaching to trigger the alarm, within `evaluation_periods`. Defaults to `evaluation_periods` when null. | `number` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | (Optional) Dimensions of the metric. CloudWatch treats each unique dimension combination as a separate metric and never aggregates over one that was not published, so this must match exactly the combination the emitting service uses. A combination that does not match leaves the alarm in INSUFFICIENT\_DATA indefinitely instead of failing. | `map(string)` | `{}` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | (Required) Number of periods over which data is compared to the threshold. | `number` | n/a | yes |
| <a name="input_extended_statistic"></a> [extended\_statistic](#input\_extended\_statistic) | (Optional) Percentile statistic (p0.0 through p100). Mutually exclusive with `statistic`. | `string` | `null` | no |
| <a name="input_insufficient_data_actions"></a> [insufficient\_data\_actions](#input\_insufficient\_data\_actions) | (Optional) ARNs to execute when the alarm transitions to INSUFFICIENT\_DATA. | `list(string)` | `[]` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | (Required) Name of the metric, e.g. `HealthyHostCount`. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Required) Namespace of the metric, e.g. `AWS/NetworkELB`. | `string` | n/a | yes |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | (Optional) ARNs to execute when the alarm transitions to OK. | `list(string)` | `[]` | no |
| <a name="input_period"></a> [period](#input\_period) | (Required) Period in seconds over which the statistic is applied. Valid values are 10, 20, 30, or any multiple of 60. | `number` | n/a | yes |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | (Optional) Statistic to apply: SampleCount, Average, Sum, Minimum or Maximum. Mutually exclusive with `extended_statistic`. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Tags applied to the alarm. | `map(string)` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | (Optional) Value against which the statistic is compared. Required for static-threshold alarms. | `number` | `null` | no |
| <a name="input_treat_missing_data"></a> [treat\_missing\_data](#input\_treat\_missing\_data) | (Optional) How to handle missing datapoints: missing, ignore, breaching or notBreaching. Null leaves the provider default (`missing`). | `string` | `null` | no |
| <a name="input_unit"></a> [unit](#input\_unit) | (Optional) Unit of the metric. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alarm_name"></a> [alarm\_name](#output\_alarm\_name) | Name of the CloudWatch alarm. |
| <a name="output_arn"></a> [arn](#output\_arn) | Amazon Resource Name of the CloudWatch alarm. |
| <a name="output_id"></a> [id](#output\_id) | ID of the CloudWatch alarm (its name). |
<!-- END_TF_DOCS -->
