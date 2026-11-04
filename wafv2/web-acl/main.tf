# Scope CLOUDFRONT só existe em us-east-1: a WebACL precisa ser criada lá, mesmo que o resto
# do ambiente esteja em outra região. Scope REGIONAL (ALB/API Gateway) vai na região do alvo.
#
# A priority de cada rule vem do índice da lista, mas o for_each é chaveado pelo NOME do rule
# group — reordenar a lista renumera as priorities sem recriar rule nenhuma.
resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = {
      for idx, group in var.managed_rule_groups : group.name => merge(group, { priority = idx })
    }

    content {
      name     = rule.value.name
      priority = rule.value.priority

      # `override_action` (e não `action`) porque quem decide allow/block dentro de um managed
      # rule group é o próprio grupo. `count` = modo observação: conta o match e deixa passar.
      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name

          # Rebaixa rules específicas do grupo pra `count` sem tirar o grupo inteiro do modo
          # bloqueio — é como se trata falso-positivo pontual (ex.: SizeRestrictions_BODY).
          dynamic "rule_action_override" {
            for_each = rule.value.count_rules
            content {
              name = rule_action_override.value
              action_to_use {
                count {}
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Re-bloqueio por label: a rule do managed group fica em `count_rules` (só emite o label) e
  # esta rule bloqueia quem carrega o label, exceto as rotas em `except_uri_regex`. É a forma
  # de abrir exceção de falso-positivo por rota sem desarmar a rule pra API inteira. A
  # priority vem DEPOIS de todos os managed groups — o label só existe depois que o grupo
  # avaliou o request.
  dynamic "rule" {
    for_each = {
      for idx, r in var.label_block_rules : r.name => merge(r, { priority = length(var.managed_rule_groups) + idx })
    }

    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        block {}
      }

      statement {
        # Sem exceção: só o label.
        dynamic "label_match_statement" {
          for_each = rule.value.except_uri_regex == null ? [1] : []
          content {
            scope = "LABEL"
            key   = rule.value.label
          }
        }

        # Com exceção: label AND NOT uri ~ regex.
        dynamic "and_statement" {
          for_each = rule.value.except_uri_regex == null ? [] : [1]
          content {
            statement {
              label_match_statement {
                scope = "LABEL"
                key   = rule.value.label
              }
            }

            statement {
              not_statement {
                statement {
                  regex_match_statement {
                    regex_string = rule.value.except_uri_regex

                    field_to_match {
                      uri_path {}
                    }

                    text_transformation {
                      priority = 0
                      type     = "NONE"
                    }
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = var.tags
}
