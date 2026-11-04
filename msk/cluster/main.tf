resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  enhanced_monitoring    = var.enhanced_monitoring

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.client_subnets
    security_groups = var.security_group_ids

    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }

    connectivity_info {
      public_access {
        type = "DISABLED"
      }
    }
  }

  client_authentication {
    sasl {
      iam = var.sasl_iam_enabled
    }
    unauthenticated = var.unauthenticated_enabled
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.kms_key_arn

    encryption_in_transit {
      client_broker = var.client_broker_encryption
      in_cluster    = var.encryption_in_cluster
    }
  }

  # Empty var.server_properties = no configuration_info, so the cluster runs on
  # MSK's default configuration for kafka_version (prod's parity scenario —
  # describe-cluster-v2 there shows no custom configuration_info). Attaching or
  # changing it is in-place (UpdateClusterConfiguration) but rolls every broker.
  dynamic "configuration_info" {
    for_each = length(var.server_properties) > 0 ? [1] : []
    content {
      arn      = aws_msk_configuration.this[0].arn
      revision = aws_msk_configuration.this[0].latest_revision
    }
  }

  tags = var.tags
}

resource "aws_msk_configuration" "this" {
  count          = length(var.server_properties) > 0 ? 1 : 0
  name           = var.cluster_name
  kafka_versions = [var.kafka_version]
  server_properties = join("\n", [
    for k, v in var.server_properties : "${k} = ${v}"
  ])

  # A configuration attached to a cluster can't be deleted — replacement
  # (e.g. a kafka_version bump) has to create the new one first.
  lifecycle {
    create_before_destroy = true
  }
}
