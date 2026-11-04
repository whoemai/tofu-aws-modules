output "zone_id" {
  description = "The ID of the hosted zone the VPC was associated with."
  value       = aws_route53_zone_association.this.zone_id
}

output "vpc_id" {
  description = "The ID of the VPC that was associated."
  value       = aws_route53_zone_association.this.vpc_id
}

output "owning_account" {
  description = "The account ID that owns the hosted zone."
  value       = aws_route53_zone_association.this.owning_account
}
