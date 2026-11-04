variable "name" {
  description = "Nome da policy. Único por conta+região."
  type        = string
}

variable "comment" {
  description = "Comentário — aparece no console, onde o nome sozinho não diz quem usa."
  type        = string
  default     = null
}

variable "cors_config" {
  # Campos 1:1 com o bloco `cors_config` do provider — nada de reduzir isso a um toggle
  # bool tipo "enable_cors": cada campo aqui é obrigatório/opcional exatamente como na
  # API, senão qualquer combinação que a AWS aceita mas o módulo não previu fica
  # impossível de configurar.
  type = object({
    access_control_allow_credentials = bool
    access_control_allow_headers     = list(string)
    access_control_allow_methods     = list(string)
    access_control_allow_origins     = list(string)
    access_control_expose_headers    = optional(list(string), [])
    access_control_max_age_sec       = optional(number)
    # `origin_override`: se true, estes headers substituem os que a origem já mandou;
    # se false, só preenche quando a origem não mandou nada.
    origin_override = bool
  })
  default     = null
  description = "(Opcional) - Configuração de CORS. Omitido = sem bloco cors_config na policy."
}

variable "security_headers_config" {
  # Mesmo princípio do cors_config: cada sub-bloco espelha o schema do provider
  # (`aws_cloudfront_response_headers_policy.security_headers_config`), não uma
  # simplificação opinativa.
  type = object({
    content_type_options = optional(object({
      override = bool
    }))
    frame_options = optional(object({
      frame_option = string # DENY ou SAMEORIGIN
      override     = bool
    }))
    referrer_policy = optional(object({
      referrer_policy = string
      override        = bool
    }))
    strict_transport_security = optional(object({
      access_control_max_age_sec = number
      include_subdomains         = optional(bool, false)
      preload                    = optional(bool, false)
      override                   = bool
    }))
    xss_protection = optional(object({
      protection = bool
      mode_block = optional(bool, false)
      report_uri = optional(string)
      override   = bool
    }))
    content_security_policy = optional(object({
      content_security_policy = string
      override                = bool
    }))
  })
  default     = null
  description = "(Opcional) - Security headers. Omitido = sem bloco security_headers_config na policy."
}
