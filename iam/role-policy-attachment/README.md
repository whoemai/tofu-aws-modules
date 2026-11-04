# IAM Role Policy Attachment Module

Attaches one or more IAM policies (customer managed or AWS managed) to an existing IAM role.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "eks_node_role_attachments" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//iam/role-policy-attachment"

  role_name = aws_iam_role.eks_node.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]
}
```

## Terragrunt Example

```hcl
dependency "role" {
  config_path = "../../roles/eks-node"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//iam/role-policy-attachment"
}

inputs = {
  role_name = dependency.role.outputs.name

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]
}
```

## Inputs

- `role_name` (string, required): Name of the IAM role to attach the policies to.
- `policy_arns` (list(string), required): ARNs of the policies to attach — works for both customer managed policies (e.g. created by the `iam/policy` module) and AWS managed policies (e.g. `arn:aws:iam::aws:policy/AmazonEKSClusterPolicy`).

## Outputs

- `policy_arns`: ARNs of the policies attached to the role.

## Notes

- Each entry in `policy_arns` becomes its own `aws_iam_role_policy_attachment` resource (`for_each` over the list), so attachments can be added or removed independently without recreating the others.
