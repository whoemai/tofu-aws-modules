# EC2 Launch Template Module

General-purpose launch template. Every field beyond `name` is optional and
left out of the generated template when unset/empty/null — including
`image_id`/`instance_type`, so it can be attached to an EKS Managed Node
Group without conflicting with the node group's own
`ami_type`/`instance_types` management.

## Use case

EKS Managed Node Groups don't propagate a `Name` tag to the underlying EC2
instances from the node group's own `tags` input — the instances show up
unnamed in the EC2 console. Attaching a launch template with
`instance_tags = { Name = "..." }` fixes this.

## Terraform Example

```hcl
module "node_launch_template" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//ec2/launch-template"

  name = "my-node-group-lt"

  instance_tags = {
    Name = "my-node-group"
  }
  volume_tags = {
    Name = "my-node-group"
  }
}
```

## Terragrunt Example

```hcl
terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//ec2/launch-template"
}

inputs = {
  name = "tools-eks-node-group-lt"

  instance_tags = {
    Name = "tools-eks-node-group"
  }
  volume_tags = {
    Name = "tools-eks-node-group"
  }
}
```

Then reference it from `eks/node-group`:

```hcl
dependency "launch_template" {
  config_path = "../../ec2/launch-templates/tools-node-group"
}

inputs = {
  # ... resto dos inputs do node group ...
  launch_template = {
    id      = dependency.launch_template.outputs.id
    version = "$Latest"
  }
}
```

## Inputs

- `name` (string, required): Name of the launch template.
- `image_id` (string, optional): AMI ID. Null leaves it out of the template (EKS Managed Node Group use case).
- `instance_type` (string, optional): Instance type. Null leaves it out of the template (EKS Managed Node Group use case).
- `key_name` (string, optional): Key pair name.
- `user_data` (string, optional): Plain-text user data — the module base64-encodes it.
- `vpc_security_group_ids` (list(string), optional): Security group IDs. Empty leaves it out of the template.
- `iam_instance_profile_arn` (string, optional): Instance profile ARN. Null leaves it out of the template.
- `block_device_mappings` (list(object), optional): Block device mappings (`device_name` + optional nested `ebs {...}`). Empty leaves it out of the template.
- `metadata_options` (object, optional): IMDS options (`http_endpoint`, `http_tokens`, `http_put_response_hop_limit`, `instance_metadata_tags`). Null leaves it out of the template — set `http_tokens = "required"` to force IMDSv2.
- `instance_tags` (map(string), optional): Tags applied to EC2 instances launched from this template.
- `volume_tags` (map(string), optional): Tags applied to EBS volumes launched from this template.
- `network_interface_tags` (map(string), optional): Tags applied to ENIs launched from this template.
- `tags` (map(string), optional): Tags applied to the launch template resource itself.

## Outputs

- `id`: ID of the launch template.
- `arn`: ARN of the launch template.
- `latest_version`: Latest version number of the launch template.

## Notes

- The template never sets `update_default_version` — publishing a new version never moves the `$Default` pointer as a side effect (e.g. of a tag-only change). Bump the version pointer intentionally at the call site if you need to.
- Use `version = "$Latest"` in the EKS node group's `launch_template` block to always track the newest version without needing to bump a pinned number.
