# Só consulta a API quando há prefixos para resolver.
data "aws_ecr_repositories" "all" {
  count = length(var.repository_prefixes) > 0 ? 1 : 0

  region = var.region
}

locals {
  by_prefix = [
    for name in try(data.aws_ecr_repositories.all[0].names, []) : name
    if length([for p in var.repository_prefixes : p if startswith(name, p)]) > 0
  ]

  repositories = toset([
    for name in distinct(concat(var.repositories, local.by_prefix)) : name
    if !contains(var.exclude_repositories, name)
  ])

  # A API do ECR reordena as regras por rulePriority; fora de ordem o recurso
  # é recriado a cada plan. Por isso a policy é montada em ordem crescente.
  rules_by_priority = { for r in var.rules : format("%012d", r.priority) => r }
  sorted_rules      = [for k in sort(keys(local.rules_by_priority)) : local.rules_by_priority[k]]

  policy = jsonencode({
    rules = [
      for r in local.sorted_rules : merge(
        { rulePriority = r.priority },
        r.description != "" ? { description = r.description } : {},
        {
          selection = merge(
            {
              tagStatus   = r.tag_status
              countType   = r.count_type
              countNumber = r.count_number
            },
            r.count_type == "sinceImagePushed" ? { countUnit = r.count_unit } : {},
            length(r.tag_pattern_list) > 0 ? { tagPatternList = r.tag_pattern_list } : {},
            length(r.tag_prefix_list) > 0 ? { tagPrefixList = r.tag_prefix_list } : {},
          )
          action = { type = "expire" }
      })
    ]
  })
}

# PutLifecyclePolicy substitui a policy inteira do repositório: qualquer regra
# criada à mão (ou pelo Terraform legado) no repo alvo é sobrescrita.
resource "aws_ecr_lifecycle_policy" "this" {
  for_each = local.repositories

  repository = each.value
  policy     = local.policy
  region     = var.region
}
