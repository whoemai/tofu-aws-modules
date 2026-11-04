resource "aws_ami_copy" "this" {
  name              = var.name
  description       = var.description
  source_ami_id     = var.source_ami_id
  source_ami_region = var.source_ami_region

  deprecation_time        = var.deprecation_time
  destination_outpost_arn = var.destination_outpost_arn
  encrypted               = var.encrypted
  kms_key_id              = var.kms_key_id
  region                  = var.region

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = var.tags
}
