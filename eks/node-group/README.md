# EKS Node Group Module

Creates an AWS EKS managed Node Group (Auto Scaling Group of Kubernetes worker nodes).

## Requirements

- OpenTofu >= 1.0
- Provider: opentofu/aws >= 6.45.0

## Terraform Example

```hcl
module "node_group" {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/node-group"

  cluster_name  = aws_eks_cluster.example.name
  node_role_arn = aws_iam_role.node.arn
  subnet_ids    = [aws_subnet.a.id, aws_subnet.b.id]

  desired_size = 2
  min_size     = 1
  max_size     = 4

  instance_types = ["t3.medium"]
  capacity_type  = "ON_DEMAND"

  tags = {
    Name = "example"
  }
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

dependency "node_role" {
  config_path = "../../iam/roles/eks-node"
}

terraform {
  source = "git::ssh://git@your-git-host/your-org/opentofu-aws-modules.git//eks/node-group"
}

inputs = {
  cluster_name  = dependency.cluster.outputs.name
  node_role_arn = dependency.node_role.outputs.arn
  subnet_ids    = dependency.network.outputs.private_subnet_ids

  desired_size = 2
  min_size     = 1
  max_size     = 4

  instance_types = ["m6i.large"]
  capacity_type  = "ON_DEMAND"

  tags = {
    Name = "example"
  }
}
```

## Inputs

- `cluster_name` (string, required): Name of the EKS Cluster.
- `node_role_arn` (string, required): ARN of the IAM Role for the node group.
- `subnet_ids` (list(string), required): Subnet IDs for the node group.
- `desired_size` (number, required): Desired number of worker nodes.
- `max_size` (number, required): Maximum number of worker nodes.
- `min_size` (number, required): Minimum number of worker nodes.
- `node_group_name` (string, optional): Name of the node group. Conflicts with `node_group_name_prefix`.
- `node_group_name_prefix` (string, optional): Prefix for a generated name. Conflicts with `node_group_name`.
- `ami_type` (string, optional): AMI type for the node group.
- `capacity_type` (string, optional): `ON_DEMAND` or `SPOT`.
- `disk_size` (number, optional): Disk size in GiB.
- `force_update_version` (bool, optional): Force version update if pods cannot be drained due to a PDB.
- `instance_types` (list(string), optional): Instance types. Default: `["t3.medium"]`.
- `labels` (map(string), optional): Kubernetes labels managed via the EKS API.
- `release_version` (string, optional): AMI release version.
- `kubernetes_version` (string, optional): Kubernetes version. Defaults to the cluster's version.
- `launch_template` (object, optional): `id` or `name`, and `version`. Conflicts with `remote_access`.
- `remote_access` (object, optional): `ec2_ssh_key`, `source_security_group_ids`. Conflicts with `launch_template`.
- `update_config` (object, optional): `max_unavailable`, `max_unavailable_percentage`, `update_strategy` (`MINIMAL` or `DEFAULT`).
- `taints` (list(object), optional): `key`, `value`, `effect` (`NO_SCHEDULE`, `NO_EXECUTE`, `PREFER_NO_SCHEDULE`). Max 50.
- `node_repair_config` (object, optional): `enabled` — enables node auto repair.
- `warm_pool_config` (object, optional): `max_group_prepared_capacity`, `min_size`, `pool_state`, `reuse_on_scale_in`. Including this block enables the warm pool.
- `tags` (map(string), optional): Resource tags.

## Outputs

- `id`: EKS Cluster name and Node Group name separated by a colon.
- `arn`: ARN of the node group.
- `node_group_name`: Name of the node group.
- `status`: Status of the node group.
- `autoscaling_group_names`: Names of the underlying Auto Scaling Groups.
- `remote_access_security_group_id`: Security group ID created for remote access, if `remote_access` is set.

## Notes

- Attach `AmazonEKSWorkerNodePolicy`, `AmazonEKS_CNI_Policy`, and `AmazonEC2ContainerRegistryReadOnly` (or equivalents) to `node_role_arn` before creating the node group, and ensure that attachment happens before (and is destroyed after) the node group.
- `desired_size` drift caused by autoscaling is expected; consider a `lifecycle { ignore_changes = [...] }` block in a wrapper module if your workflow requires it — this module intentionally does not hardcode `ignore_changes` to remain agnostic.
- `launch_template` and `remote_access` are mutually exclusive, as are `max_unavailable` and `max_unavailable_percentage` within `update_config`.
