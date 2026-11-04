
variable "repositories" {
  description = "Explicit list of ECR repository names to manage (e.g. a canary repo before rolling out by prefix)."
  type        = list(string)
  default     = []
}

variable "repository_prefixes" {
  description = "Manage every existing repository whose name starts with one of these prefixes (e.g. [\"myorg/\"]). Evaluated at plan time."
  type        = list(string)
  default     = []
}

variable "exclude_repositories" {
  description = "Repository names never managed, even if listed or matched by prefix."
  type        = list(string)
  default     = []
}

variable "region" {
  description = "Region where the lifecycle policies are managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rules" {
  description = <<-EOT
    Lifecycle rules (action is always "expire"), mirroring the ECR lifecycle policy schema:
      priority         - unique rulePriority (lower is evaluated first)
      description      - optional text
      tag_status       - "tagged", "untagged" or "any"
      tag_pattern_list - wildcard patterns, e.g. ["*-SNAPSHOT"] (tagged only)
      tag_prefix_list  - tag prefixes, e.g. ["dev-"] (tagged only)
      count_type       - "imageCountMoreThan" or "sinceImagePushed"
      count_number     - image count or age
      count_unit       - "days" (sinceImagePushed only)
  EOT
  type = list(object({
    priority         = number
    description      = optional(string, "")
    tag_status       = string
    tag_pattern_list = optional(list(string), [])
    tag_prefix_list  = optional(list(string), [])
    count_type       = string
    count_number     = number
    count_unit       = optional(string, "days")
  }))

  validation {
    condition     = length(var.rules) > 0
    error_message = "Defina ao menos uma regra."
  }

  validation {
    condition     = length(distinct([for r in var.rules : r.priority])) == length(var.rules)
    error_message = "priority precisa ser única entre as regras."
  }

  validation {
    condition     = alltrue([for r in var.rules : contains(["tagged", "untagged", "any"], r.tag_status)])
    error_message = "tag_status precisa ser tagged, untagged ou any."
  }

  validation {
    condition     = alltrue([for r in var.rules : contains(["imageCountMoreThan", "sinceImagePushed"], r.count_type)])
    error_message = "count_type precisa ser imageCountMoreThan ou sinceImagePushed."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.tag_status != "tagged" || length(r.tag_pattern_list) + length(r.tag_prefix_list) > 0
    ])
    error_message = "Regra com tag_status = tagged precisa de tag_pattern_list ou tag_prefix_list."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.tag_status == "tagged" || length(r.tag_pattern_list) + length(r.tag_prefix_list) == 0
    ])
    error_message = "tag_pattern_list/tag_prefix_list só valem para tag_status = tagged."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      length(r.tag_pattern_list) == 0 || length(r.tag_prefix_list) == 0
    ])
    error_message = "Use tag_pattern_list ou tag_prefix_list na mesma regra, não os dois."
  }

  validation {
    condition = alltrue([
      for r in var.rules :
      r.tag_status != "any" || r.priority == max([for x in var.rules : x.priority]...)
    ])
    error_message = "Regra com tag_status = any precisa ter a maior priority (o ECR avalia por último)."
  }
}
