# EKS Pod Identity Association Module

Associates a Kubernetes service account with an IAM role using EKS Pod Identity, so pods running with that service account receive temporary, automatically rotated IAM credentials.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0 (`policy` argument requires >= 6.40.0)

## Terraform Example

```hcl
module "app_pod_identity" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/pod-identity-association"

  cluster_name    = aws_eks_cluster.example.name
  namespace       = "example"
  service_account = "example-sa"
  role_arn        = aws_iam_role.example.arn
}
```

## Terragrunt Example

```hcl
dependency "cluster" {
  config_path = "../../eks/cluster"
}

dependency "app_role" {
  config_path = "../../iam/roles/app-service-account"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/pod-identity-association"
}

inputs = {
  cluster_name    = dependency.cluster.outputs.name
  namespace       = "example"
  service_account = "example-sa"
  role_arn        = dependency.app_role.outputs.arn
}
```

### With inline session policy

```hcl
inputs = {
  cluster_name          = dependency.cluster.outputs.name
  namespace             = "example"
  service_account       = "example-sa"
  role_arn              = dependency.app_role.outputs.arn
  disable_session_tags  = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject"]
      Resource = "arn:aws:s3:::example-bucket/*"
    }]
  })
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `namespace` (string, required): Kubernetes namespace of the service account.
- `service_account` (string, required): Name of the Kubernetes service account.
- `role_arn` (string, required): IAM role ARN to associate with the service account.
- `disable_session_tags` (bool, optional): Disable EKS-added session tags. Required to be `true` when `policy` is set.
- `policy` (string, optional): Inline IAM policy JSON further restricting the association's effective permissions (intersected with the role's own policies). Requires `disable_session_tags = true`.
- `target_role_arn` (string, optional): IAM role ARN to chain to `role_arn`.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `association_arn`: ARN of the association.
- `association_id`: ID of the association.
- `external_id`: Unique identifier to place in the target role's trust policy `Condition` (`sts:ExternalId`), when using `target_role_arn`.

## Notes

- The IAM role's trust policy must allow the `pods.eks.amazonaws.com` service principal to `sts:AssumeRole` and `sts:TagSession`.
- Prefer this module over IRSA (IAM Roles for Service Accounts, via `eks/addon`'s `service_account_role_arn`) for application workloads: it does not require an OIDC provider per cluster and roles can be reused across clusters.
