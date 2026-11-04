output "policy_arns" {
  value       = [for a in aws_iam_role_policy_attachment.this : a.policy_arn]
  description = "ARNs of the policies attached to the role."
}
