# EKS Fargate Profile Module

Creates an AWS EKS Fargate Profile, allowing pods matching the configured selectors to run on Fargate instead of EC2 worker nodes.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "fargate_profile" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/fargate-profile"

  cluster_name            = aws_eks_cluster.example.name
  fargate_profile_name    = "example"
  pod_execution_role_arn  = aws_iam_role.fargate.arn
  subnet_ids              = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  selectors = [
    { namespace = "example" }
  ]
}
```

## Terragrunt Example

```hcl
dependency "cluster" {
  config_path = "../cluster"
}

dependency "network" {
  config_path = "../../vpc/network"
}

dependency "fargate_role" {
  config_path = "../../iam/roles/eks-fargate"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/fargate-profile"
}

inputs = {
  cluster_name           = dependency.cluster.outputs.name
  fargate_profile_name   = "default"
  pod_execution_role_arn = dependency.fargate_role.outputs.arn
  subnet_ids             = dependency.network.outputs.private_subnet_ids

  selectors = [
    { namespace = "kube-system" },
    { namespace = "default", labels = { workload = "fargate" } }
  ]

  tags = {
    Name = "example"
  }
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `fargate_profile_name` (string, required): Name of the Fargate Profile.
- `pod_execution_role_arn` (string, required): ARN of the IAM Role for the Fargate Profile.
- `subnet_ids` (list(string), required): Private subnet IDs. Each subnet must be tagged `kubernetes.io/cluster/<CLUSTER_NAME>`.
- `selectors` (list(object), required): At least one selector with `namespace` (required) and `labels` (optional).
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: EKS Cluster name and Fargate Profile name separated by a colon.
- `arn`: ARN of the Fargate Profile.
- `status`: Status of the Fargate Profile.

## Notes

- Attach `AmazonEKSFargatePodExecutionRolePolicy` to `pod_execution_role_arn` with a trust policy allowing `eks-fargate-pods.amazonaws.com`.
- Subnets used for Fargate profiles must be private; public subnets are not supported.
