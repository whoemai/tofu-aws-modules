# image_id/instance_type/security_groups/iam_instance_profile/user_data continuam
# opcionais (default null) — quando null, ficam de fora do template, que é o caso do
# EKS Managed Node Group (ami_type/instance_types controlados só pelo node group).
# Usado standalone (ex.: ec2/autoscaling/auto_scaling_group fora do EKS) eles entram.
resource "aws_launch_template" "this" {
  name          = var.name
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = var.user_data != null ? base64encode(var.user_data) : null

  vpc_security_group_ids = length(var.vpc_security_group_ids) > 0 ? var.vpc_security_group_ids : null

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_arn != null ? [1] : []
    content {
      arn = var.iam_instance_profile_arn
    }
  }

  dynamic "tag_specifications" {
    for_each = length(var.instance_tags) > 0 ? [1] : []
    content {
      resource_type = "instance"
      tags          = var.instance_tags
    }
  }

  # 🪤 Ordem dos blocos importa: tag_specifications é lista, não set — AWS retorna e o
  # provider guarda na ordem em que foram declarados na criação. instance/network-interface/
  # volume é a ordem real usada pelas units existentes; trocar a ordem aqui gera diff de
  # update-in-place (na prática, publica versão nova do launch template) mesmo com o mesmo
  # conteúdo.
  dynamic "tag_specifications" {
    for_each = length(var.network_interface_tags) > 0 ? [1] : []
    content {
      resource_type = "network-interface"
      tags          = var.network_interface_tags
    }
  }

  dynamic "tag_specifications" {
    for_each = length(var.volume_tags) > 0 ? [1] : []
    content {
      resource_type = "volume"
      tags          = var.volume_tags
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name

      dynamic "ebs" {
        for_each = block_device_mappings.value.ebs != null ? [block_device_mappings.value.ebs] : []
        content {
          volume_size           = try(ebs.value.volume_size, null)
          volume_type           = try(ebs.value.volume_type, null)
          delete_on_termination = try(ebs.value.delete_on_termination, null)
          encrypted             = try(ebs.value.encrypted, null)
          kms_key_id            = try(ebs.value.kms_key_id, null)
          iops                  = try(ebs.value.iops, null)
          throughput            = try(ebs.value.throughput, null)
          snapshot_id           = try(ebs.value.snapshot_id, null)
        }
      }
    }
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options != null ? [var.metadata_options] : []
    content {
      http_endpoint               = try(metadata_options.value.http_endpoint, null)
      http_tokens                 = try(metadata_options.value.http_tokens, null)
      http_put_response_hop_limit = try(metadata_options.value.http_put_response_hop_limit, null)
      instance_metadata_tags      = try(metadata_options.value.instance_metadata_tags, null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
