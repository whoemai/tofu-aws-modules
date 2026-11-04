variable "identifier" {
  description = "Identificador da instância RDS (ex. \"app-mysql\") — também nomeia SG, subnet group e parameter group"
  type        = string
}

variable "engine" {
  description = "Engine: \"mysql\" ou \"postgres\". Define a porta (3306/5432) e a família do parameter group."
  type        = string

  validation {
    condition     = contains(["mysql", "postgres"], var.engine)
    error_message = "engine deve ser \"mysql\" ou \"postgres\"."
  }
}

variable "engine_version" {
  description = "Versão exata da engine no RDS (ex.: \"8.4.10\" para MySQL ou \"16.13\" para PostgreSQL)."
  type        = string
}

variable "instance_class" {
  description = "Classe da instância RDS (ex. db.t4g.medium)."
  type        = string
  default     = "db.t4g.medium"
}

variable "allocated_storage" {
  description = "Storage inicial em GB"
  type        = number
  default     = 50
}

variable "max_allocated_storage" {
  description = "Teto do autoscaling de storage em GB. 0 desliga o autoscaling."
  type        = number
  default     = 100
}

variable "database_name" {
  description = "Database inicial criado junto com a instância. Para PostgreSQL o RDS já cria `postgres` por padrão."
  type        = string
  default     = null
}

variable "master_username" {
  description = "Usuário master (ex.: \"root\" no MySQL, \"postgres\" no PostgreSQL)."
  type        = string
}

variable "master_secret_name" {
  description = "Nome do secret no Secrets Manager onde a credencial master é publicada (ex. \"prod/rds/mysql/master\")."
  type        = string
}

variable "vpc_id" {
  description = "VPC onde o Security Group do banco é criado"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets privadas do DB subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security Groups autorizados a abrir conexão na porta do banco (ex.: SG dos nós do EKS)."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDRs extras liberados na porta do banco."
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Atribui IP público à instância."
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Parâmetros do parameter group: lista de {name, value, apply_method}"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "parameter_group_family" {
  description = "Família do parameter group. Vazio = derivada de engine+engine_version (ex. \"mysql8.4\")."
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "Dias de retenção de backup. 1 é o mínimo que mantém snapshot automático ligado."
  type        = number
  default     = 1
}

variable "storage_type" {
  description = "Tipo de storage do banco (\"gp3\" recomendado)."
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "storage_type deve ser \"standard\", \"gp2\", \"gp3\", \"io1\" ou \"io2\"."
  }
}

variable "storage_encrypted" {
  description = "Cifra o storage da instância. Ignorado (sempre true) quando kms_key_id é informado."
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Cria standby síncrono em outra AZ."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pula o snapshot final ao destruir a instância (use false em produção)."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Bloqueia destroy/console de apagar a instância sem antes desligar esta flag."
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "Propaga as tags da instância para os snapshots (automáticos e manuais)."
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Aplica minor version upgrade automaticamente na maintenance window."
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Habilita Performance Insights na instância RDS."
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Intervalo (segundos) do Enhanced Monitoring. 0 desliga. Valores aceitos pela AWS: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "monitoring_interval deve ser 0, 1, 5, 10, 15, 30 ou 60."
  }
}

variable "apply_immediately" {
  description = "Aplica mudanças de configuração imediatamente em vez de aguardar a maintenance window."
  type        = bool
  default     = true
}

variable "dns_cname" {
  description = "Hostname CNAME opcional gravado no secret master (ex. db.app.example.com)."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = <<-EOT
    ARN da CMK que cifra o storage da instância e o secret com a credencial master.
    `null` usa as chaves gerenciadas pela AWS (`aws/rds` e `aws/secretsmanager`).
    ⚠️ Alterar este valor em uma instância já criada força replace.
  EOT
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = <<-EOT
    Tipos de log exportados para o CloudWatch:
      mysql    — error, general, slowquery, audit
      postgres — postgresql, upgrade
  EOT
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs_retention_days" {
  description = "Retenção em dias dos log groups criados no CloudWatch."
  type        = number
  default     = 30
}

variable "iam_database_authentication_enabled" {
  description = "Habilita autenticação de banco de dados por token IAM além da senha."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas aos recursos do módulo"
  type        = map(string)
  default     = {}
}
