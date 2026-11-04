# Target Group Attachment Module

Registers a single target (EC2 instance, IP, or Lambda) with an existing
`ec2/elb/target-group`. Kept as its own module — the attachment is a separate resource
from the target group and from the instance being registered, so it can be composed
with any of them independently.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| target_group_arn | ARN of the target group | string | - | yes |
| target_id | Instance ID, IP address, or Lambda ARN, depending on the target group's `tg_target_type` | string | - | yes |
| port | Port the target receives traffic on. Null uses the target group's own port | number | null | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Unique identifier for the attachment |

## Terragrunt example

```hcl
terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//ec2/elb/target-group-attachment"
}

dependency "target_group" {
  config_path = "../target-group/example"
}

dependency "instance" {
  config_path = "../../ec2-instance/example"
}

inputs = {
  target_group_arn = dependency.target_group.outputs.target_group_arn
  target_id        = dependency.instance.outputs.instance_id
}
```
