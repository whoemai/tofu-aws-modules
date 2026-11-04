
output "registry_ids" {
  description = "Map of repository name to the registry ID where the repository was created."
  value       = { for name, p in aws_ecr_lifecycle_policy.this : name => p.registry_id }
}

output "repositories" {
  description = "Repositories whose lifecycle policy is managed by this module."
  value       = sort(tolist(local.repositories))
}

output "policy" {
  description = "Lifecycle policy JSON applied to every managed repository."
  value       = local.policy
}
