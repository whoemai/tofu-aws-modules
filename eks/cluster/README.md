# EKS Cluster Module

Creates an AWS EKS Cluster (control plane). Supports standard clusters, EKS Auto Mode, EKS Hybrid Nodes, and Outposts, through optional configuration blocks.

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "eks_cluster" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/cluster"

  name               = "example"
  role_arn           = aws_iam_role.cluster.arn
  kubernetes_version = "1.31"
  subnet_ids         = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id]

  endpoint_private_access = true
  endpoint_public_access  = true

  tags = {
    Name = "example"
  }
}
```

## Terragrunt Example

```hcl
dependency "network" {
  config_path = "../../vpc/network"
}

dependency "cluster_role" {
  config_path = "../../iam/roles/eks-cluster"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/cluster"
}

inputs = {
  name               = "example"
  role_arn           = dependency.cluster_role.outputs.arn
  kubernetes_version = "1.31"
  subnet_ids         = dependency.network.outputs.private_subnet_ids

  endpoint_private_access = true
  endpoint_public_access  = true

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  tags = {
    Name = "example"
  }
}
```

### EKS Auto Mode

```hcl
inputs = {
  name               = "example"
  role_arn           = dependency.cluster_role.outputs.arn
  subnet_ids         = dependency.network.outputs.private_subnet_ids

  bootstrap_self_managed_addons = false

  compute_config = {
    enabled       = true
    node_pools    = ["general-purpose"]
    node_role_arn = dependency.node_role.outputs.arn
  }

  kubernetes_network_config = {
    elastic_load_balancing_enabled = true
  }

  storage_config_block_storage_enabled = true

  tags = {
    Name = "example"
  }
}
```

## Inputs

- `name` (string, required): Name of the cluster.
- `role_arn` (string, required): ARN of the IAM role for the Kubernetes control plane.
- `subnet_ids` (list(string), required): Subnet IDs across at least two availability zones.
- `kubernetes_version` (string, optional): Desired Kubernetes version.
- `endpoint_private_access` (bool, optional): Enable the private API server endpoint. Default: `false`.
- `endpoint_public_access` (bool, optional): Enable the public API server endpoint. Default: `true`.
- `public_access_cidrs` (list(string), optional): CIDR blocks allowed to access the public endpoint.
- `security_group_ids` (list(string), optional): Additional security group IDs for the cross-account ENIs.
- `bootstrap_self_managed_addons` (bool, optional): Install default unmanaged add-ons on creation. Must be `false` to enable EKS Auto Mode.
- `deletion_protection` (bool, optional): Enable deletion protection. Default: `false`.
- `enabled_cluster_log_types` (list(string), optional): Control plane log types to enable (e.g. `api`, `audit`, `authenticator`, `controllerManager`, `scheduler`).
- `force_update_version` (bool, optional): Force version update by overriding upgrade-blocking readiness checks.
- `access_config` (object, optional): `authentication_mode` (`CONFIG_MAP`, `API`, or `API_AND_CONFIG_MAP`) and `bootstrap_cluster_creator_admin_permissions`.
- `encryption_config` (object, optional): `resources` (must be `["secrets"]`) and `provider_key_arn` (KMS key ARN).
- `kubernetes_network_config` (object, optional): `service_ipv4_cidr`, `ip_family`, `elastic_load_balancing_enabled` (for EKS Auto Mode).
- `compute_config` (object, optional): `enabled`, `node_pools`, `node_role_arn` for EKS Auto Mode.
- `storage_config_block_storage_enabled` (bool, optional): Enable EKS Auto Mode block storage capability.
- `outpost_config` (object, optional): `control_plane_instance_type`, `outpost_arns` for local clusters on AWS Outposts.
- `upgrade_policy_support_type` (string, optional): `EXTENDED` or `STANDARD`.
- `zonal_shift_config_enabled` (bool, optional): Enable zonal shift for the cluster.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: Name of the cluster.
- `arn`: ARN of the cluster.
- `name`: Name of the cluster.
- `endpoint`: Endpoint for the Kubernetes API server.
- `version`: Kubernetes version of the cluster.
- `status`: Status of the cluster.
- `certificate_authority_data`: Base64 encoded certificate data for `kubeconfig`.
- `oidc_issuer_url`: OIDC issuer URL, used to set up IAM Roles for Service Accounts (IRSA).
- `cluster_security_group_id`: Security group created by EKS for the cluster.
- `vpc_id`: VPC ID associated with the cluster.
- `platform_version`: Platform version for the cluster.

## Notes

- Attach `AmazonEKSClusterPolicy` (and, for EKS Auto Mode, `AmazonEKSComputePolicy`, `AmazonEKSBlockStoragePolicy`, `AmazonEKSLoadBalancingPolicy`, `AmazonEKSNetworkingPolicy`) to `role_arn` before creating the cluster, and ensure the attachment is created before (and destroyed after) the cluster to avoid orphaned EKS-managed EC2 resources.
- This module only manages the control plane. Use `eks/node-group` or `eks/fargate-profile` to run workloads.
