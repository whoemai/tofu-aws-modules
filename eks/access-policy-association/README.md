# EKS Access Policy Association Module

Associates an EKS access policy (e.g. `AmazonEKSClusterAdminPolicy`, `AmazonEKSViewPolicy`) with an IAM principal on a cluster, scoped to the whole cluster or specific namespaces.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "sre_admin_policy" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/access-policy-association"

  cluster_name      = aws_eks_cluster.example.name
  principal_arn     = aws_iam_role.sre.arn
  policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope_type = "cluster"
}
```

## Terragrunt Example

```hcl
dependency "cluster" {
  config_path = "../cluster"
}

dependency "access_entry" {
  config_path = "../access-entry/sre"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/access-policy-association"
}

inputs = {
  cluster_name      = dependency.cluster.outputs.name
  principal_arn     = dependency.access_entry.outputs.principal_arn
  policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope_type = "cluster"
}
```

### Namespace-scoped access

```hcl
inputs = {
  cluster_name             = dependency.cluster.outputs.name
  principal_arn            = dependency.access_entry.outputs.principal_arn
  policy_arn               = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  access_scope_type        = "namespace"
  access_scope_namespaces  = ["example-namespace"]
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `policy_arn` (string, required): ARN of the EKS access policy to associate.
- `principal_arn` (string, required): IAM Principal ARN requiring access to the cluster.
- `access_scope_type` (string, required): `namespace` or `cluster`.
- `access_scope_namespaces` (list(string), optional): Namespaces the scope applies to, when `access_scope_type = "namespace"`.

## Outputs

- `associated_at`: Date and time the policy was associated.
- `modified_at`: Date and time the policy association was last updated.

## Notes

- The IAM principal must already have an Access Entry on the cluster (see `eks/access-entry`) before a policy association can be created.
- AWS-managed access policy ARNs follow the pattern `arn:aws:eks::aws:cluster-access-policy/<PolicyName>` (e.g. `AmazonEKSClusterAdminPolicy`, `AmazonEKSAdminPolicy`, `AmazonEKSEditPolicy`, `AmazonEKSViewPolicy`).
