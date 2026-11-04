variable "name" {
  description = "Nome do OAC. Único por conta."
  type        = string
}

variable "description" {
  description = "Descrição do OAC — aparece no console, onde o nome sozinho não diz qual distribuição usa."
  type        = string
  default     = null
}

variable "origin_type" {
  description = "Tipo da origem assinada: s3, mediastore, lambda ou mediapackagev2."
  type        = string
  default     = "s3"
}

variable "signing_behavior" {
  description = <<-EOT
    Quando assinar: `always` (assina tudo, o normal), `never` (desliga) ou
    `no-override` (só assina se o viewer não mandou Authorization).
  EOT
  type        = string
  default     = "always"
}

variable "signing_protocol" {
  description = "Protocolo de assinatura. sigv4 é o único aceito hoje."
  type        = string
  default     = "sigv4"
}
