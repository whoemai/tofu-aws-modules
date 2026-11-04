resource "aws_cloudfront_distribution" "acd" {

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.origin_id
      origin_access_control_id = try(origin.value.origin_access_control_id, null)
      origin_path              = try(origin.value.origin_path, "")

      dynamic "custom_header" {
        for_each = try(origin.value.custom_headers, [])
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = try(origin.value.custom_origin_config, null) != null ? [origin.value.custom_origin_config] : []
        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }
    }
  }

  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object

  # WAFv2 quer o ARN aqui; o nome do argumento sobrou do WAF Classic, que usava id. Passar o
  # id de uma WebACL v2 falha no apply com "WAFInvalidParameterException".
  web_acl_id = var.web_acl_id

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      include_cookies = logging_config.value.include_cookies
      bucket          = logging_config.value.bucket
      prefix          = try(logging_config.value.prefix, "")
    }
  }

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods
    target_origin_id = var.default_cache_behavior.target_origin_id

    # cache_policy_id/origin_request_policy_id/response_headers_policy_id são ARGUMENTOS
    # do provider, não blocos — um `dynamic "cache_policy_id"` é HCL inválido (dynamic só
    # existe pra bloco aninhado).
    cache_policy_id            = try(var.default_cache_behavior.cache_policy_id, null)
    origin_request_policy_id   = try(var.default_cache_behavior.origin_request_policy_id, null)
    response_headers_policy_id = try(var.default_cache_behavior.response_headers_policy_id, null)

    # Fallback para forwarded_values (deprecated, mas ainda suportado)
    dynamic "forwarded_values" {
      for_each = try(var.default_cache_behavior.cache_policy_id, null) == null ? [var.default_cache_behavior.forwarded_values] : []
      content {
        query_string = forwarded_values.value.query_string
        headers      = try(forwarded_values.value.headers, [])

        dynamic "cookies" {
          for_each = try(forwarded_values.value.cookies, null) != null ? [forwarded_values.value.cookies] : []
          content {
            forward           = cookies.value.forward
            whitelisted_names = try(cookies.value.whitelisted_names, [])
          }
        }
      }
    }

    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    # null (não 0/86400/31536000) por default: com cache_policy_id setado, a API recusa
    # qualquer TTL explícito aqui.
    min_ttl     = try(var.default_cache_behavior.min_ttl, null)
    default_ttl = try(var.default_cache_behavior.default_ttl, null)
    max_ttl     = try(var.default_cache_behavior.max_ttl, null)
    compress    = try(var.default_cache_behavior.compress, true)
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern               = ordered_cache_behavior.value.path_pattern
      allowed_methods            = ordered_cache_behavior.value.allowed_methods
      cached_methods             = ordered_cache_behavior.value.cached_methods
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      cache_policy_id            = try(ordered_cache_behavior.value.cache_policy_id, null)
      origin_request_policy_id   = try(ordered_cache_behavior.value.origin_request_policy_id, null)
      response_headers_policy_id = try(ordered_cache_behavior.value.response_headers_policy_id, null)

      dynamic "forwarded_values" {
        for_each = try(ordered_cache_behavior.value.cache_policy_id, null) == null ? [ordered_cache_behavior.value.forwarded_values] : []
        content {
          query_string = forwarded_values.value.query_string
          headers      = try(forwarded_values.value.headers, [])

          dynamic "cookies" {
            for_each = try(forwarded_values.value.cookies, null) != null ? [forwarded_values.value.cookies] : []
            content {
              forward           = cookies.value.forward
              whitelisted_names = try(cookies.value.whitelisted_names, [])
            }
          }
        }
      }

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      min_ttl                = try(ordered_cache_behavior.value.min_ttl, null)
      default_ttl            = try(ordered_cache_behavior.value.default_ttl, null)
      max_ttl                = try(ordered_cache_behavior.value.max_ttl, null)
      compress               = try(ordered_cache_behavior.value.compress, true)
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  price_class = var.price_class

  # Bloco obrigatório no provider mesmo sem restrição nenhuma — por isso não é mais
  # `dynamic` condicionado a `!= null` (com restrictions = null, o apply falhava).
  restrictions {
    geo_restriction {
      restriction_type = var.restrictions.geo_restriction.restriction_type
      locations        = var.restrictions.geo_restriction.locations
    }
  }

  dynamic "viewer_certificate" {
    for_each = [var.viewer_certificate]
    content {
      cloudfront_default_certificate = try(viewer_certificate.value.cloudfront_default_certificate, false)
      acm_certificate_arn            = try(viewer_certificate.value.acm_certificate_arn, null)
      ssl_support_method             = try(viewer_certificate.value.ssl_support_method, null)
      minimum_protocol_version       = try(viewer_certificate.value.minimum_protocol_version, "TLSv1")
      iam_certificate_id             = try(viewer_certificate.value.iam_certificate_id, null)
    }
  }

  tags = var.tags
}