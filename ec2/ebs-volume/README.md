# EBS Volume Module

Creates a standalone EBS volume and attaches it to an existing EC2 instance — for
attaching a data disk to an instance built by another module (e.g. `ec2/ec2-instance`),
where `ebs_volumes` isn't a fit because the instance isn't managed by that module call.

## Requirements

- OpenTofu >= 1.0
- Provider: hashicorp/aws >= 4.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name tag for the EBS volume | string | - | yes |
| availability_zone | AZ for the volume — must match the attached instance's AZ | string | - | yes |
| size | Size of the volume, in GiB | number | - | yes |
| type | Volume type (gp2, gp3, io1, io2, sc1, st1, standard) | string | "gp3" | no |
| encrypted | Whether the volume is encrypted at rest | bool | true | no |
| iops | Provisioned IOPS — required for io1/io2, optional tuning for gp3 | number | null | no |
| throughput | Throughput in MiB/s (gp3 only) | number | null | no |
| kms_key_id | KMS key ARN for encryption. Null uses the AWS-managed EBS key | string | null | no |
| device_name | Device name exposed to the instance (e.g. /dev/xvdf) | string | - | yes |
| instance_id | ID of the EC2 instance to attach this volume to | string | - | yes |
| force_detach | Force detach on destroy, even if still mounted in-guest | bool | false | no |
| stop_instance_before_detaching | Stop the instance before detaching, then leave it stopped | bool | false | no |
| tags | Tags to apply to the volume | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the EBS volume |
| arn | ARN of the EBS volume |

## Terragrunt example

```hcl
terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//ec2/ebs-volume"
}

dependency "instance" {
  config_path = "../../ec2/ec2-instance/example"
}

inputs = {
  name              = "example-sql-data"
  availability_zone = dependency.instance.outputs.availability_zone
  size              = 1000
  type              = "gp3"
  device_name       = "/dev/xvdf"
  instance_id       = dependency.instance.outputs.instance_id

  tags = {
    Name = "example-sql-data"
  }
}
```

## Notes

- `availability_zone` isn't derived from `instance_id` — pass the instance's own AZ output explicitly, since EBS volumes and their target instance must live in the same AZ or the attachment fails.
- Detaching (via `stop_instance_before_detaching` and/or `force_detach`) matters most for a destroy/replace — a plain `apply` never needs them.
