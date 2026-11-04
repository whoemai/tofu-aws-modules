variable "domain_name" {
  description = <<-EOT
    Nome da hosted zone pública (subdomínio delegado). Ex.: "app.example.com".
    O certificado ACM cobre este nome + o wildcard "*.<domain_name>".
    Após o apply, crie registros NS na zona-mãe apontando para os `name_servers`
    de output deste módulo para completar a delegação DNS.
  EOT
  type        = string
}

variable "subject_alternative_names" {
  description = "SANs extras no certificado ACM, além de domain_name + *.domain_name (normalmente vazio)."
  type        = list(string)
  default     = []
}

variable "wait_for_validation" {
  description = <<-EOT
    Se true, o apply aguarda o ACM emitir o certificado — o que exige a delegação NS já
    configurada na zona-mãe. No primeiro apply, se a delegação ainda não existir, rode com
    false para criar zona + cert + registros de validação; configure a delegação NS na
    zona-mãe (com os name_servers de output); então rode novamente com true.
  EOT
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais aplicadas à zona e ao certificado"
  type        = map(string)
  default     = {}
}
