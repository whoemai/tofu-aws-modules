# EKS Access Entry Module

Manages an AWS EKS Access Entry, granting an IAM principal authentication access to a cluster using EKS Access Entries (`API` or `API_AND_CONFIG_MAP` authentication mode).

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "sre_access_entry" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/access-entry"

  cluster_name  = aws_eks_cluster.example.name
  principal_arn = aws_iam_role.sre.arn
}
```

## Terragrunt Example

```hcl
dependency "cluster" {
  config_path = "../cluster"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/access-entry"
}

inputs = {
  cluster_name  = dependency.cluster.outputs.name
  principal_arn = "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_PS-SRE-Administrator_xxxxxxxxxxxxxxxx"

  tags = {
    Name = "example"
  }
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `principal_arn` (string, required): IAM Principal ARN requiring access to the cluster.
- `kubernetes_groups` (list(string), optional): Kubernetes groups the principal belongs to.
- `type` (string, optional): `STANDARD` (default), `EC2_LINUX`, `EC2_WINDOWS`, or `FARGATE_LINUX`.
- `user_name` (string, optional): Overrides the default username derived from the principal ARN.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `access_entry_arn`: ARN of the Access Entry.
- `principal_arn`: IAM Principal ARN associated with the Access Entry.

## Notes

- Requires the cluster's `access_config.authentication_mode` to be `API` or `API_AND_CONFIG_MAP` (see `eks/cluster`).
- An Access Entry alone grants no permissions; pair it with `eks/access-policy-association` to associate Kubernetes RBAC-equivalent access policies.
