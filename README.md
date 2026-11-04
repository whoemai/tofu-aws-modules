# Módulos AWS para OpenTofu/Terraform

<p align="center">
  <img src="assets/logo.jpeg" alt="OpenTofu AWS Modules" width="100%">
</p>

> Módulos simples e limpos para uso.

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.0-blue?style=flat-square)
![OpenTofu](https://img.shields.io/badge/OpenTofu-%3E%3D1.6-yellow?style=flat-square)
![AWS Provider](https://img.shields.io/badge/AWS%20Provider-%3E%3D6.0-orange?style=flat-square)
![Modules](https://img.shields.io/badge/modules-123-brightgreen?style=flat-square)
![Maintained](https://img.shields.io/badge/maintained%3F-yes-brightgreen?style=flat-square)

## Sumário

- [Sobre](#sobre)
- [Primeiros Passos](#primeiros-passos)
- [Pré-requisitos](#pré-requisitos)
- [Módulos Disponíveis](#módulos-disponíveis)
- [Contribuindo](#contribuindo)

---

## Sobre

Este repositório contém uma **coleção abrangente de módulos Terraform/OpenTofu** para serviços da AWS, organizados por categoria de serviço. Cada módulo foi projetado para ser:

- **Simples e Limpo**: Complexidade mínima com opções claras de configuração
- **Pronto para Produção**: Segue as boas práticas e diretrizes de segurança da AWS
- **Bem Documentado**: Cada módulo inclui arquivos README detalhados com exemplos
- **Modular**: Pode ser usado de forma independente ou combinado com outros módulos
- **Compatível com Terraform/OpenTofu**: Funciona tanto com Terraform quanto com OpenTofu

---

## Primeiros Passos

### Organização do Repositório

Este repositório é organizado por **categorias de serviços da AWS**, com cada serviço contendo um ou mais módulos especializados. A estrutura de diretórios segue uma hierarquia clara:

```sh
tofu-aws-modules/
|-- service-name/           # Serviço AWS (ex.: vpc, ecs, s3)
|   |-- module-name/        # Módulo específico (ex.: vpc, subnet, security-group)
|   |   |-- main.tf         # Definições principais de recursos
|   |   |-- variables.tf    # Variáveis de entrada (inputs)
|   |   |-- outputs.tf      # Valores de saída (outputs)
|   |   `-- README.md       # Documentação do módulo (terraform-docs)
```

Alguns módulos ficam um ou dois níveis mais abaixo (por exemplo, `vpc/transit-gateway/tgw` e `elasticache/redis/standalone/cache_redis`). O caminho listado na tabela de [Módulos Disponíveis](#módulos-disponíveis) é sempre o que deve ser utilizado no atributo `source`.

**Pontos-chave:**
- Cada módulo é **autossuficiente** e pode ser utilizado de forma independente
- Os módulos seguem **convenções consistentes de nomenclatura** e estrutura
- A maioria dos módulos inclui um **README** gerado pelo terraform-docs (veja a coluna **Docs** em [Módulos Disponíveis](#módulos-disponíveis))
- As variáveis são **bem documentadas**, com descrições e valores padrão
- Os outputs são **claramente definidos** para facilitar a integração com outros módulos

### Convenção de Uso dos Módulos

Os módulos são referenciados utilizando o seguinte padrão:

```hcl
module "resource_name" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//service/module-name?ref=<tag>"

  # Sua configuração aqui
}
```

Sempre fixe o parâmetro `?ref=` em uma tag. Com o Terragrunt, o mesmo endereço vai no `source` do bloco `terraform` da unit.

---

## Pré-requisitos

Antes de utilizar estes módulos, certifique-se de ter:

- **Terraform** >= 1.0 ou **OpenTofu** >= 1.6 instalado
- **AWS CLI** configurado com credenciais válidas
- **AWS Provider** configurado no seu código. Os módulos não fixam uma versão específica, portanto a restrição vem do seu módulo raiz (o repositório do Terragrunt utiliza `>= 6.61.0`)
- **Permissões IAM** adequadas para criar os recursos

### Configuração Básica do Provider

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

---

## Módulos Disponíveis

São 123 módulos distribuídos em 33 pastas de serviços. A coluna **Docs** indica se o módulo possui seu próprio `README.md` (com inputs, outputs e exemplos no formato do terraform-docs). Um módulo sem essa documentação continua pronto para uso: basta consultar seus arquivos `variables.tf` e `outputs.tf`.

Algumas pastas contêm mais de um módulo para o mesmo recurso (por exemplo, `vpc/security-group`, `ec2/loadbalancer/*` e `ec2/elb/*`). Cada um deles é um módulo independente com seu próprio caminho de `source`.

### ACM

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`acm/certificate`](./acm/certificate/) | `aws_acm_certificate` | ✅ |
| [`acm/certificate-validation`](./acm/certificate-validation/) | `aws_acm_certificate_validation` | ✅ |

### AMI

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`ami/ami`](./ami/ami/) | `aws_ami` | ✅ |
| [`ami/copy`](./ami/copy/) | `aws_ami_copy` | ✅ |

### AWS Backup

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`backup/plan`](./backup/plan/) | `aws_backup_plan` | — |
| [`backup/selection`](./backup/selection/) | `aws_backup_selection`, `aws_iam_role`, `aws_iam_role_policy_attachment` | — |
| [`backup/vault`](./backup/vault/) | `aws_backup_vault` | — |

### Cloud Map

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`cloudmap/service-discovery`](./cloudmap/service-discovery/) | `aws_service_discovery_private_dns_namespace`, `aws_service_discovery_service` | ✅ |

### Cloud9

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`cloud9`](./cloud9/) | `aws_cloud9_environment_ec2` | — |

### CloudFront

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`cloudfront/cloudfront-distribution`](./cloudfront/cloudfront-distribution/) | `aws_cloudfront_distribution` | ✅ |
| [`cloudfront/origin-access-control`](./cloudfront/origin-access-control/) | `aws_cloudfront_origin_access_control` | ✅ |
| [`cloudfront/response-headers-policy`](./cloudfront/response-headers-policy/) | `aws_cloudfront_response_headers_policy` | ✅ |

### CloudWatch

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`cloudwatch/log-group`](./cloudwatch/log-group/) | `aws_cloudwatch_log_group` | ✅ |
| [`cloudwatch/log-stream`](./cloudwatch/log-stream/) | `aws_cloudwatch_log_stream` | — |
| [`cloudwatch/metric-alarm`](./cloudwatch/metric-alarm/) | `aws_cloudwatch_metric_alarm` | ✅ |

### Data Sources

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`datasources/aws_secretsmanager_secret`](./datasources/aws_secretsmanager_secret/) | `aws_secretsmanager_secret`, `aws_secretsmanager_secret_version` | — |

### DMS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`dms/dms_certificate`](./dms/dms_certificate/) | `aws_dms_certificate` | — |
| [`dms/dms_endpoint`](./dms/dms_endpoint/) | `aws_dms_endpoint` | — |
| [`dms/dms_event_subscription`](./dms/dms_event_subscription/) | `aws_dms_event_subscription` | — |
| [`dms/dms_replication_instance`](./dms/dms_replication_instance/) | `aws_dms_replication_instance` | — |
| [`dms/dms_replication_subnet_group`](./dms/dms_replication_subnet_group/) | `aws_dms_replication_subnet_group` | — |
| [`dms/dms_task`](./dms/dms_task/) | `aws_dms_replication_task` | — |
| [`dms/event_subscription`](./dms/event_subscription/) | `aws_dms_event_subscription` | — |

### DocumentDB

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`documentdb/cluster_instance`](./documentdb/cluster_instance/) | `aws_docdb_cluster`, `aws_docdb_cluster_instance`, `aws_docdb_cluster_parameter_group` | — |

### DynamoDB

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`dynamodb`](./dynamodb/) | `aws_dynamodb_table` | ✅ |
| [`dynamodb/tables`](./dynamodb/tables/) | `aws_dynamodb_table` | ✅ |

### EC2 / ELB

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`ec2/autoscaling/auto_scaling_group`](./ec2/autoscaling/auto_scaling_group/) | `aws_autoscaling_group` | — |
| [`ec2/autoscaling/launch_configuration`](./ec2/autoscaling/launch_configuration/) | `aws_launch_configuration` | — |
| [`ec2/ebs-encryption-by-default`](./ec2/ebs-encryption-by-default/) | `aws_ebs_encryption_by_default` | ✅ |
| [`ec2/ebs-volume`](./ec2/ebs-volume/) | `aws_ebs_volume`, `aws_volume_attachment` | ✅ |
| [`ec2/ec2-instance`](./ec2/ec2-instance/) | `aws_ebs_volume`, `aws_iam_instance_profile`, `aws_iam_role`, `aws_iam_role_policy_attachment`, `aws_instance`, `aws_route53_record`, `aws_security_group`, `aws_security_group_rule`, `aws_volume_attachment` | ✅ |
| [`ec2/elb/lb`](./ec2/elb/lb/) | `aws_lb`, `aws_lb_listener` | ✅ |
| [`ec2/elb/target-group`](./ec2/elb/target-group/) | `aws_lb_target_group` | ✅ |
| [`ec2/elb/target-group-attachment`](./ec2/elb/target-group-attachment/) | `aws_lb_target_group_attachment` | ✅ |
| [`ec2/key-pair`](./ec2/key-pair/) | `aws_key_pair` | ✅ |
| [`ec2/launch-template`](./ec2/launch-template/) | `aws_launch_template` | ✅ |
| [`ec2/loadbalancer/alb`](./ec2/loadbalancer/alb/) | `aws_lb`, `aws_lb_listener` | — |
| [`ec2/loadbalancer/alb/listener_certificate`](./ec2/loadbalancer/alb/listener_certificate/) | `aws_lb_listener_certificate` | — |
| [`ec2/loadbalancer/elb`](./ec2/loadbalancer/elb/) | `aws_elb` | — |
| [`ec2/loadbalancer/nlb`](./ec2/loadbalancer/nlb/) | `aws_lb` | — |

### ECR

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`ecr/lifecycle-policy`](./ecr/lifecycle-policy/) | `aws_ecr_lifecycle_policy` | ✅ |
| [`ecr/private`](./ecr/private/) | `aws_ecr_repository` | ✅ |

### ECS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`ecs/cluster`](./ecs/cluster/) | `aws_ecs_cluster`, `aws_ecs_cluster_capacity_providers` | ✅ |
| [`ecs/service`](./ecs/service/) | `aws_ecs_service` | ✅ |
| [`ecs/task-definition`](./ecs/task-definition/) | `aws_ecs_task_definition` | ✅ |

### EFS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`efs/file_system`](./efs/file_system/) | `aws_efs_file_system` | — |
| [`efs/mount_target`](./efs/mount_target/) | `aws_efs_mount_target` | — |

### EKS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`eks/access-entry`](./eks/access-entry/) | `aws_eks_access_entry` | ✅ |
| [`eks/access-policy-association`](./eks/access-policy-association/) | `aws_eks_access_policy_association` | ✅ |
| [`eks/addon`](./eks/addon/) | `aws_eks_addon` | ✅ |
| [`eks/cluster`](./eks/cluster/) | `aws_eks_cluster` | ✅ |
| [`eks/fargate-profile`](./eks/fargate-profile/) | `aws_eks_fargate_profile` | ✅ |
| [`eks/node-group`](./eks/node-group/) | `aws_eks_node_group` | ✅ |
| [`eks/pod-identity-association`](./eks/pod-identity-association/) | `aws_eks_pod_identity_association` | ✅ |

### ElastiCache

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`elasticache/memcached/standalone/cache_memcached`](./elasticache/memcached/standalone/cache_memcached/) | `aws_elasticache_cluster` | — |
| [`elasticache/redis/cluster/replication_group`](./elasticache/redis/cluster/replication_group/) | `aws_elasticache_replication_group` | — |
| [`elasticache/redis/standalone/cache_redis`](./elasticache/redis/standalone/cache_redis/) | `aws_elasticache_cluster` | — |
| [`elasticache/replication-group`](./elasticache/replication-group/) | `aws_elasticache_replication_group` | ✅ |
| [`elasticache/subnet-group`](./elasticache/subnet-group/) | `aws_elasticache_subnet_group` | — |

### EventBridge

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`eventbridge/cw-event-api-destination`](./eventbridge/cw-event-api-destination/) | `aws_cloudwatch_event_api_destination` | — |
| [`eventbridge/cw-event-archive`](./eventbridge/cw-event-archive/) | `aws_cloudwatch_event_archive` | — |
| [`eventbridge/cw-event-bus`](./eventbridge/cw-event-bus/) | `aws_cloudwatch_event_bus` | — |
| [`eventbridge/cw-event-rule`](./eventbridge/cw-event-rule/) | `aws_cloudwatch_event_rule` | — |
| [`eventbridge/cw-event-target`](./eventbridge/cw-event-target/) | `aws_cloudwatch_event_target` | — |
| [`eventbridge/scheduler-schedule`](./eventbridge/scheduler-schedule/) | `aws_scheduler_schedule` | — |

### IAM

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`iam/groups/group`](./iam/groups/group/) | `aws_iam_group` | ✅ |
| [`iam/instance_profile`](./iam/instance_profile/) | `aws_iam_instance_profile` | — |
| [`iam/oidc-provider`](./iam/oidc-provider/) | `aws_iam_openid_connect_provider` | ✅ |
| [`iam/policy`](./iam/policy/) | `aws_iam_policy`, `aws_iam_role_policy_attachment`, `aws_iam_user_policy_attachment` | ✅ |
| [`iam/role`](./iam/role/) | `aws_iam_role` | ✅ |
| [`iam/role-policy-attachment`](./iam/role-policy-attachment/) | `aws_iam_role_policy_attachment` | ✅ |
| [`iam/service-linked-role`](./iam/service-linked-role/) | `aws_iam_service_linked_role` | ✅ |
| [`iam/users/user`](./iam/users/user/) | `aws_iam_access_key`, `aws_iam_user` | ✅ |

### Kinesis

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`kinesis/consumer`](./kinesis/consumer/) | `aws_kinesis_stream_consumer` | — |
| [`kinesis/firehose/s3-destination`](./kinesis/firehose/s3-destination/) | `aws_kinesis_firehose_delivery_stream` | — |
| [`kinesis/stream`](./kinesis/stream/) | `aws_kinesis_stream` | — |

### KMS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`kms/key`](./kms/key/) | `aws_kms_alias`, `aws_kms_key` | ✅ |
| [`kms/kms-alias`](./kms/kms-alias/) | `aws_kms_alias`, `aws_kms_key` | ✅ |

### Lambda

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`lambda/function`](./lambda/function/) | `aws_lambda_function`, `aws_lambda_function_url` | ✅ |
| [`lambda/permission`](./lambda/permission/) | `aws_lambda_permission` | — |

### MSK

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`msk/cluster`](./msk/cluster/) | `aws_msk_cluster`, `aws_msk_configuration` | — |

### RDS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`rds/db-option-group`](./rds/db-option-group/) | `aws_db_option_group` | ✅ |
| [`rds/db-parameter-group`](./rds/db-parameter-group/) | `aws_db_parameter_group` | ✅ |
| [`rds/db-subnet-group`](./rds/db-subnet-group/) | `aws_db_subnet_group` | ✅ |
| [`rds/instance`](./rds/instance/) | `aws_cloudwatch_log_group`, `aws_db_instance`, `aws_db_parameter_group`, `aws_db_subnet_group`, `aws_secretsmanager_secret`, `aws_secretsmanager_secret_version`, `aws_security_group`, `aws_vpc_security_group_egress_rule`, `aws_vpc_security_group_ingress_rule`, `random_password` | ✅ |
| [`rds/rds-cluster`](./rds/rds-cluster/) | `aws_rds_cluster` | ✅ |
| [`rds/rds-instance`](./rds/rds-instance/) | `aws_db_instance` | ✅ |

### Route 53

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`route53/alias-record`](./route53/alias-record/) | `aws_route53_record` | ✅ |
| [`route53/hosted_zones`](./route53/hosted_zones/) | `aws_route53_zone` | ✅ |
| [`route53/records`](./route53/records/) | `aws_route53_record` | ✅ |
| [`route53/vpc-association-authorization`](./route53/vpc-association-authorization/) | `aws_route53_vpc_association_authorization` | ✅ |
| [`route53/zone-association`](./route53/zone-association/) | `aws_route53_zone_association` | ✅ |
| [`route53/zone-with-acm`](./route53/zone-with-acm/) | `aws_acm_certificate`, `aws_acm_certificate_validation`, `aws_route53_record`, `aws_route53_zone` | ✅ |

### S3

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`s3/bucket-acl`](./s3/bucket-acl/) | `aws_s3_bucket`, `aws_s3_bucket_accelerate_configuration`, `aws_s3_bucket_acl`, `aws_s3_bucket_cors_configuration`, `aws_s3_bucket_lifecycle_configuration`, `aws_s3_bucket_logging`, `aws_s3_bucket_ownership_controls`, `aws_s3_bucket_policy`, `aws_s3_bucket_public_access_block`, `aws_s3_bucket_server_side_encryption_configuration`, `aws_s3_bucket_versioning` | ✅ |
| [`s3/bucket-lifecycle-configuration`](./s3/bucket-lifecycle-configuration/) | `aws_s3_bucket_lifecycle_configuration` | ✅ |
| [`s3/bucket-static-webhosting`](./s3/bucket-static-webhosting/) | `aws_s3_bucket`, `aws_s3_bucket_acl`, `aws_s3_bucket_policy`, `aws_s3_bucket_website_configuration` | ✅ |

### SageMaker

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`sagemaker/aws_sagemaker_endpoint`](./sagemaker/aws_sagemaker_endpoint/) | `aws_sagemaker_endpoint` | — |
| [`sagemaker/aws_sagemaker_endpoint_configuration`](./sagemaker/aws_sagemaker_endpoint_configuration/) | `aws_sagemaker_endpoint_configuration` | — |
| [`sagemaker/aws_sagemaker_model`](./sagemaker/aws_sagemaker_model/) | `aws_sagemaker_model` | — |

### Secrets Manager

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`secrets-manager/random-secret`](./secrets-manager/random-secret/) | `aws_secretsmanager_secret`, `aws_secretsmanager_secret_version`, `random_password` | ✅ |
| [`secrets-manager/secret`](./secrets-manager/secret/) | `aws_secretsmanager_secret`, `aws_secretsmanager_secret_version`, `random_password` | ✅ |

### SNS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`sns/subscription`](./sns/subscription/) | `aws_sns_topic_subscription` | — |
| [`sns/topic`](./sns/topic/) | `aws_sns_topic` | — |

### SQS

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`sqs/queue`](./sqs/queue/) | `aws_sqs_queue`, `aws_sqs_queue_policy`, `aws_sqs_queue_redrive_allow_policy`, `aws_sqs_queue_redrive_policy` | ✅ |

### SSM

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`ssm/parameter`](./ssm/parameter/) | `aws_ssm_parameter`, `random_password` | ✅ |
| [`ssm/parameters`](./ssm/parameters/) | `aws_ssm_parameter`, `random_password` | ✅ |

### VPC

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`vpc/elastic-ip`](./vpc/elastic-ip/) | `aws_eip` | ✅ |
| [`vpc/endpoint`](./vpc/endpoint/) | `aws_vpc_endpoint` | ✅ |
| [`vpc/endpoint-service`](./vpc/endpoint-service/) | `aws_vpc_endpoint_service` | — |
| [`vpc/internet-gateway`](./vpc/internet-gateway/) | `aws_internet_gateway` | ✅ |
| [`vpc/nat-gateway`](./vpc/nat-gateway/) | `aws_nat_gateway` | ✅ |
| [`vpc/peering`](./vpc/peering/) | `aws_vpc_peering_connection`, `aws_vpc_peering_connection_accepter`, `aws_vpc_peering_connection_options` | ✅ |
| [`vpc/route-table`](./vpc/route-table/) | `aws_route`, `aws_route_table`, `aws_route_table_association` | ✅ |
| [`vpc/security-group`](./vpc/security-group/) | `aws_security_group` | ✅ |
| [`vpc/security-group/custom`](./vpc/security-group/custom/) | `aws_security_group` | ✅ |
| [`vpc/security-group/default`](./vpc/security-group/default/) | `aws_default_security_group` | ✅ |
| [`vpc/security-group/managed`](./vpc/security-group/managed/) | `aws_security_group`, `aws_vpc_security_group_egress_rule`, `aws_vpc_security_group_ingress_rule` | ✅ |
| [`vpc/subnet`](./vpc/subnet/) | `aws_subnet` | ✅ |
| [`vpc/transit-gateway/attachements/vpc-attachment`](./vpc/transit-gateway/attachements/vpc-attachment/) | `aws_ec2_transit_gateway_vpc_attachment` | ✅ |
| [`vpc/transit-gateway/tgw`](./vpc/transit-gateway/tgw/) | `aws_ec2_transit_gateway` | ✅ |
| [`vpc/vpc`](./vpc/vpc/) | `aws_vpc`, `aws_vpc_block_public_access_exclusion`, `aws_vpc_block_public_access_options` | ✅ |
| [`vpc/vpns/site-2-site`](./vpc/vpns/site-2-site/) | `aws_customer_gateway`, `aws_vpn_connection`, `aws_vpn_connection_route`, `aws_vpn_gateway` | ✅ |

### WAFv2

| Módulo | Recursos principais | Docs |
|--------|---------------------|:----:|
| [`wafv2/web-acl`](./wafv2/web-acl/) | `aws_wafv2_web_acl` | ✅ |

---

## Contribuindo

Contribuições são bem-vindas! Se você quiser contribuir:

1. Faça um **Fork** do repositório
2. Crie uma **feature branch** (`git checkout -b feature/nova-funcionalidade`)
3. Faça o **Commit** das suas alterações (`git commit -m 'feat(escopo): adiciona nova funcionalidade'`)
4. Faça o **Push** para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um **Pull Request**

### Diretrizes

- Utilize Conventional Commits com o escopo do módulo (por exemplo, `fix(sqs-queue): ...` ou `fix(sqs/queue): ...`)
- Execute `tofu fmt -check -recursive` e `tofu validate` no módulo alterado
- Confira variáveis e outputs com a documentação do provider, sem valores fixos (hard-coded)
- Gere novamente o `README.md` do módulo com o `terraform-docs` e atualize esta tabela ao adicionar ou remover um módulo
- Descreva o impacto para os consumidores no Pull Request e sinalize qualquer **BREAKING CHANGE**
- Mantenha os módulos simples e focados
