# AWS ECR Lifecycle Policy Module

OpenTofu module to apply the same ECR lifecycle policy to a set of existing ECR repositories, selected by explicit name and/or by name prefix.

## Table of Contents

- [AWS ECR Lifecycle Policy Module](#aws-ecr-lifecycle-policy-module)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Usage](#usage)
    - [Minimal Terragrunt Example](#minimal-terragrunt-example)
    - [Terragrunt Example](#terragrunt-example)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Notes](#notes)

## Features

- Applies one lifecycle policy to many repositories at once
- Selects repositories by explicit name, by prefix, or both
- Excludes specific repositories from management
- Rules mirror the ECR lifecycle policy schema (action is always `expire`)
- Validates rule priorities, tag settings and count types
- Only looks up existing repositories when `repository_prefixes` is set
- Optional `region` to manage repositories outside the provider's default Region
- Rules are rendered in ascending `priority` order, which avoids a perpetual diff since the ECR API reorders rules by `rulePriority`

## Usage

### Minimal Terragrunt Example

Only the required inputs: one explicit repository and one rule. No prefix lookup is performed.

```hcl
terraform {
  source = "[...]"
}

inputs = {
  repositories = ["myorg/canary-app"]

  rules = [
    {
      priority     = 1
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_number = 7
    }
  ]
}
```

### Terragrunt Example

Complete example using prefix discovery, exclusions, a custom Region and the three kinds of rule.

```hcl
terraform {
  source = "[...]"
}

inputs = {
  region = "us-east-1"

  repository_prefixes  = ["myorg/"]
  repositories         = ["shared/base-image"]
  exclude_repositories = ["myorg/legacy-app"]

  rules = [
    {
      priority     = 1
      description  = "Expire untagged images after 7 days"
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = 7
    },
    {
      priority         = 2
      description      = "Expire snapshot images after 30 days"
      tag_status       = "tagged"
      tag_pattern_list = ["*-SNAPSHOT"]
      count_type       = "sinceImagePushed"
      count_number     = 30
    },
    {
      priority        = 3
      description     = "Keep only the last 10 dev images"
      tag_status      = "tagged"
      tag_prefix_list = ["dev-"]
      count_type      = "imageCountMoreThan"
      count_number    = 10
    },
    {
      priority     = 4
      description  = "Keep only the last 50 images"
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = 50
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repositories.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repositories) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_repositories"></a> [exclude\_repositories](#input\_exclude\_repositories) | Repository names never managed, even if listed or matched by prefix. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where the lifecycle policies are managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | Explicit list of ECR repository names to manage (e.g. a canary repo before rolling out by prefix). | `list(string)` | `[]` | no |
| <a name="input_repository_prefixes"></a> [repository\_prefixes](#input\_repository\_prefixes) | Manage every existing repository whose name starts with one of these prefixes (e.g. ["myorg/"]). Evaluated at plan time. | `list(string)` | `[]` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Lifecycle rules (action is always "expire"), mirroring the ECR lifecycle policy schema:<br>  priority         - unique rulePriority (lower is evaluated first)<br>  description      - optional text<br>  tag\_status       - "tagged", "untagged" or "any"<br>  tag\_pattern\_list - wildcard patterns, e.g. ["*-SNAPSHOT"] (tagged only)<br>  tag\_prefix\_list  - tag prefixes, e.g. ["dev-"] (tagged only)<br>  count\_type       - "imageCountMoreThan" or "sinceImagePushed"<br>  count\_number     - image count or age<br>  count\_unit       - "days" (sinceImagePushed only) | <pre>list(object({<br>    priority         = number<br>    description      = optional(string, "")<br>    tag_status       = string<br>    tag_pattern_list = optional(list(string), [])<br>    tag_prefix_list  = optional(list(string), [])<br>    count_type       = string<br>    count_number     = number<br>    count_unit       = optional(string, "days")<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy"></a> [policy](#output\_policy) | Lifecycle policy JSON applied to every managed repository. |
| <a name="output_registry_ids"></a> [registry\_ids](#output\_registry\_ids) | Map of repository name to the registry ID where the repository was created. |
| <a name="output_repositories"></a> [repositories](#output\_repositories) | Repositories whose lifecycle policy is managed by this module. |
<!-- END_TF_DOCS -->

## Notes

- `PutLifecyclePolicy` replaces the whole policy of a repository: any rule created manually (or by other IaC code) on a managed repository is overwritten
- Prefix matching is evaluated at plan time, so repositories created later are only picked up on the next plan/apply
- Using `repository_prefixes` requires the `ecr:DescribeRepositories` permission
- A rule with `tag_status = "any"` must have the highest `priority`, since ECR evaluates it last
- Use either `tag_pattern_list` or `tag_prefix_list` in a rule, not both
