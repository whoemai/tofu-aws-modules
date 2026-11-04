# EC2 Instance Module

This OpenTofu/Terraform module creates an EC2 instance with customizable configuration including security groups, IAM roles, EBS volumes, and Route53 DNS records.

## Features

- EC2 instance with customizable instance type
- AMI selection via direct ID or filters
- Security group with configurable ingress rules
- IAM role and instance profile
- Additional EBS volumes support
- Route53 DNS record creation
- Configurable root volume size
- Support for SSH and custom port access rules

## Usage

```hcl
# terragrunt.hcl
terraform {
  source = "git::git@github.com:your-org/infra-modules.git//ec2-instance?ref=v1.0.0"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

inputs = {
  name          = "my-instance"
  instance_type = "t3.micro"
  
  ami_filters = {
    owners = ["amazon"]
    filters = [
      {
        name   = "name"
        values = ["Windows_Server-2022-English-Full-Base-*"]
      }
    ]
  }

  vpc_id    = dependency.vpc.outputs.vpc_id
  subnet_id = dependency.vpc.outputs.private_subnet_ids

  allow_ssh_from_cidr_blocks = ["10.0.0.0/8"]
  
  allow_port_from_cidr_blocks = {
    rdp = {
      from_port   = 3389
      to_port     = 3389
      protocol    = "TCP"
      cidr_blocks = ["10.0.0.0/8"]
    }
  }

  root_volume_size = 50

  tags = {
    Environment = "production"
    Project     = "example"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_route53_record.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.port_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_volume_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name of the EC2 instance | string | - | yes |
| instance_type | EC2 instance type | string | "t3.micro" | no |
| ami | AMI ID to use. If null, ami_filters will be used | string | null | no |
| ami_filters | Filters to select AMI | object | null | no |
| vpc_id | VPC ID where the instance will be created | string | - | yes |
| subnet_id | List of subnet IDs | list(string) | - | yes |
| allow_ssh_from_cidr_blocks | CIDR blocks allowed to SSH | list(string) | [] | no |
| allow_ssh_from_security_group_ids | Security groups allowed to SSH | list(string) | [] | no |
| allow_port_from_cidr_blocks | Map of port rules from CIDR blocks | map(object) | {} | no |
| allow_port_from_security_group_ids | Map of port rules from security groups | map(object) | {} | no |
| route53_zone_id | Route53 hosted zone ID | string | "" | no |
| route53_lookup_domain_name | Domain name for Route53 | string | "" | no |
| dns_zone_is_private | Whether Route53 zone is private | bool | true | no |
| root_volume_size | Size of root volume in GB | number | 30 | no |
| ebs_volumes | Map of additional EBS volumes | map(object) | {} | no |
| additional_security_group_ids | Additional security group IDs to attach, alongside the one this module creates | list(string) | [] | no |
| iam_policy_arns | Additional managed policy ARNs to attach to the instance's IAM role. Ignored when iam_instance_profile_name is set | list(string) | [] | no |
| iam_instance_profile_name | Name of an existing IAM instance profile to use instead of the one this module creates | string | null | no |
| associate_public_ip_address | Whether to associate a public IP. Null defers to the subnet's auto-assign setting | bool | null | no |
| key_name | Existing EC2 key pair name. Null attaches none (prefer SSM) | string | null | no |
| user_data | User data script (plain text). Never embed secrets | string | null | no |
| user_data_replace_on_change | Replace the instance when user_data changes instead of stop/start in place | bool | false | no |
| metadata_options | IMDS options (http_endpoint, http_tokens, http_put_response_hop_limit, instance_metadata_tags), 1:1 with aws_instance. Null omits the block | object | null | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_arn | ARN of the EC2 instance |
| private_ip | Private IP address |
| public_ip | Public IP address |
| security_group_id | Security group ID |
| iam_role_name | IAM role name |
| iam_role_arn | IAM role ARN |
| instance_profile_name | IAM instance profile name |
| ami_id | AMI ID used |
| availability_zone | Availability zone |
| dns_name | DNS name from Route53 |

## Notes

- The module creates a security group with all outbound traffic allowed
- Root volume is always encrypted (gp3 type)
- IAM role is automatically created for the instance, unless `iam_instance_profile_name` points at an existing instance profile — in that case the module attaches to it directly and does not manage a role/profile of its own
- `associate_public_ip_address` is left unset (null) by default, which defers to the subnet's auto-assign-public-IP setting — set it explicitly (e.g. `false`) when you need to guarantee no public IP regardless of subnet configuration
- AMI changes are ignored to prevent instance replacement
- `key_name`, `user_data` and `metadata_options` default to null, so existing callers get no diff. Set `metadata_options = { http_tokens = "required" }` to enforce IMDSv2. `user_data` ends up in state and in the instance attribute — fetch secrets at boot (Secrets Manager/SSM via the instance role) instead of inlining them
