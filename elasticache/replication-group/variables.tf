variable "replication_group_id" {
  description = <<-EOT
    ID do replication group (ex. "projeto-redis"). Vira o prefixo dos endpoints e a tag `Name`.

    Teto de 40 caracteres, começando por letra: o plan passa com nome maior e o apply falha em
    `InvalidParameterValue` — daí a `validation`.
  EOT
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,39}$", var.replication_group_id))
    error_message = "replication_group_id: até 40 caracteres, minúsculas/dígitos/hífen, começando por letra."
  }
}

variable "description" {
  description = "Descrição do grupo — campo obrigatório do recurso. Diz pra que serve o cache."
  type        = string
}

variable "engine" {
  description = "`redis` ou `valkey`. Trocar de engine num grupo existente é migração, não edição."
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Versão da engine. A major precisa combinar com a família do `parameter_group_name`."
  type        = string
  default     = "7.1"
}

variable "node_type" {
  description = "Classe do nó (ex. `cache.t4g.micro`). Mudar reinicia o cache — o dado em memória se perde."
  type        = string
}

variable "port" {
  description = "Porta da engine. Forced-new: a AWS não muda porta de grupo existente."
  type        = number
  default     = 6379
}

variable "num_cache_clusters" {
  description = <<-EOT
    Quantidade de nós do grupo (primário + réplicas), sem cluster mode. `1` é nó único: sem
    réplica, sem failover, e a perda do nó é perda do cache inteiro.
  EOT
  type        = number
  default     = 1
}

variable "automatic_failover_enabled" {
  description = "Failover automático pra réplica. Exige `num_cache_clusters >= 2`."
  type        = bool
  default     = false
}

variable "multi_az_enabled" {
  description = "Distribui os nós em AZs diferentes. Exige `automatic_failover_enabled = true`."
  type        = bool
  default     = false
}

variable "subnet_group_name" {
  description = "Subnet group onde o cache nasce (output `name` do `elasticache/subnet-group`)."
  type        = string
}

variable "security_group_ids" {
  description = "SGs anexados ao cache (output `id` do `vpc/security-group`). A autorização do Redis sem AUTH é puramente de rede — quem alcança a porta lê e escreve tudo."
  type        = list(string)
}

variable "parameter_group_name" {
  description = "Parameter group. `default.redis7` é o default da AWS pra Redis 7 sem cluster mode."
  type        = string
  default     = "default.redis7"
}

variable "transit_encryption_enabled" {
  description = <<-EOT
    TLS no protocolo. Ligar num grupo existente é replace, e recusa cliente que fale em texto
    plano — não é mudança só de infra.

    É pré-requisito do `auth_token`: a AWS rejeita senha sem TLS.
  EOT
  type        = bool
  default     = false
}

variable "auth_token" {
  description = <<-EOT
    Senha do Redis (16-128 caracteres imprimíveis, sem `/`, `"`, `@` e espaço). `null` = sem
    AUTH, e a autorização fica só no security group.

    Só tem efeito com `transit_encryption_enabled = true`. Quem gera e publica o valor é a
    unit — ver a seção "Gap conhecido" do README.
  EOT
  type        = string
  default     = null
  sensitive   = true
}

variable "at_rest_encryption_enabled" {
  description = "Cifra o dado em repouso e o snapshot. Forced-new."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = <<-EOT
    ARN da CMK do dado em repouso. `null` usa a chave gerenciada `aws/elasticache`, que não tem
    key policy editável.

    ⚠️ Mudar este valor num grupo existente FORÇA REPLACE — a AWS não recriptografa in-place.
  EOT
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Dias de retenção do snapshot diário. `0` desliga o backup automático."
  type        = number
  default     = 0
}

variable "apply_immediately" {
  description = "Aplica a mudança agora em vez de esperar a janela de manutenção. `true` reinicia o cache na hora."
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Deixa a AWS subir minor sozinha na janela de manutenção. `false` mantém a versão previsível."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags aplicadas ao replication group."
  type        = map(string)
  default     = {}
}
