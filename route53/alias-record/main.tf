# An alias A/AAAA record has no ttl/records — the target (CloudFront, ALB, S3 website
# endpoint) answers instead. That's why this is a separate module from route53/record:
# ttl/records and the alias block are mutually exclusive on aws_route53_record.
resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.name
  type    = var.type

  alias {
    name    = var.alias_target.name
    zone_id = var.alias_target.zone_id

    # false for a target with no health check of its own (CloudFront). true on an ALB
    # makes Route53 stop answering the name once the whole target group is unhealthy.
    evaluate_target_health = var.alias_target.evaluate_target_health
  }

  allow_overwrite = var.allow_overwrite
}
