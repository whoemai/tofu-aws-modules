# EKS Addon Module

Manages an AWS EKS add-on (e.g. `vpc-cni`, `coredns`, `kube-proxy`, `aws-ebs-csi-driver`).

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "vpc_cni_addon" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/addon"

  cluster_name = aws_eks_cluster.example.name
  addon_name   = "vpc-cni"
}
```

## Terragrunt Example

```hcl
dependency "cluster" {
  config_path = "../cluster"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/addon"
}

inputs = {
  cluster_name                = dependency.cluster.outputs.name
  addon_name                  = "coredns"
  addon_version               = "v1.11.4-eksbuild.2"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = {
    Name = "example"
  }
}
```

### With IRSA (IAM Roles for Service Accounts)

```hcl
dependency "vpc_cni_role" {
  config_path = "../../iam/roles/vpc-cni"
}

inputs = {
  cluster_name              = dependency.cluster.outputs.name
  addon_name                = "vpc-cni"
  service_account_role_arn  = dependency.vpc_cni_role.outputs.arn
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `addon_name` (string, required): Name of the EKS add-on.
- `addon_version` (string, optional): Version of the add-on. Defaults to the EKS-recommended version.
- `configuration_values` (string, optional): Custom add-on configuration as a JSON string.
- `namespace` (string, optional): Kubernetes namespace to install the add-on in.
- `preserve` (bool, optional): Preserve created resources when deleting the add-on.
- `resolve_conflicts_on_create` (string, optional): `NONE` or `OVERWRITE`.
- `resolve_conflicts_on_update` (string, optional): `NONE`, `OVERWRITE`, or `PRESERVE`.
- `service_account_role_arn` (string, optional): IAM role ARN bound to the add-on's service account (requires an OIDC provider on the cluster).
- `pod_identity_associations` (list(object), optional): `role_arn`, `service_account` — EKS Pod Identity associations for the add-on.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: EKS Cluster name and Addon name separated by a colon.
- `arn`: ARN of the add-on.
- `created_at`: Date and time in RFC3339 format that the add-on was created.
- `modified_at`: Date and time in RFC3339 format that the add-on was last modified.

## Notes

- Use `resolve_conflicts_on_update = "PRESERVE"` to keep manual `kubectl` config changes when upgrading an add-on version.
- Prefer EKS Pod Identity (`pod_identity_associations`) over IRSA (`service_account_role_arn`) for new clusters; Pod Identity does not require an OIDC provider and roles can be reused across clusters.
