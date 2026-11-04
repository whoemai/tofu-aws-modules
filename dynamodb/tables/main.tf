# PAY_PER_REQUEST em todas: elimina a decisão de capacity. PITR desligado por default.
resource "aws_dynamodb_table" "this" {
  for_each = var.tables

  name         = each.key
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = each.value.hash_key
  range_key    = each.value.range_key

  # Só atributos que participam de chave (tabela ou índice): a AWS rejeita atributo declarado
  # e não usado em chave.
  dynamic "attribute" {
    for_each = each.value.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = each.value.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      # A AWS só aceita non_key_attributes quando a projeção é INCLUDE.
      non_key_attributes = (
        global_secondary_index.value.projection_type == "INCLUDE"
        ? global_secondary_index.value.non_key_attributes
        : null
      )
    }
  }

  dynamic "local_secondary_index" {
    for_each = each.value.local_secondary_indexes
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.range_key
      projection_type = local_secondary_index.value.projection_type
      non_key_attributes = (
        local_secondary_index.value.projection_type == "INCLUDE"
        ? local_secondary_index.value.non_key_attributes
        : null
      )
    }
  }

  dynamic "ttl" {
    for_each = each.value.ttl_attribute != null ? [1] : []
    content {
      attribute_name = each.value.ttl_attribute
      enabled        = true
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  # Ambiente descartável: deletion_protection off é requisito do `run --all destroy`.
  deletion_protection_enabled = false

  tags = merge(var.tags, { Name = each.key })
}
