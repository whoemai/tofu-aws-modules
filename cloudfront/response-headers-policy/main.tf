resource "aws_cloudfront_response_headers_policy" "this" {
  name    = var.name
  comment = var.comment

  dynamic "cors_config" {
    for_each = var.cors_config != null ? [var.cors_config] : []
    content {
      access_control_allow_credentials = cors_config.value.access_control_allow_credentials
      origin_override                  = cors_config.value.origin_override

      access_control_allow_headers {
        items = cors_config.value.access_control_allow_headers
      }

      access_control_allow_methods {
        items = cors_config.value.access_control_allow_methods
      }

      access_control_allow_origins {
        items = cors_config.value.access_control_allow_origins
      }

      dynamic "access_control_expose_headers" {
        for_each = length(cors_config.value.access_control_expose_headers) > 0 ? [cors_config.value.access_control_expose_headers] : []
        content {
          items = access_control_expose_headers.value
        }
      }

      access_control_max_age_sec = try(cors_config.value.access_control_max_age_sec, null)
    }
  }

  dynamic "security_headers_config" {
    for_each = var.security_headers_config != null ? [var.security_headers_config] : []
    content {
      dynamic "content_type_options" {
        for_each = try(security_headers_config.value.content_type_options, null) != null ? [security_headers_config.value.content_type_options] : []
        content {
          override = content_type_options.value.override
        }
      }

      dynamic "frame_options" {
        for_each = try(security_headers_config.value.frame_options, null) != null ? [security_headers_config.value.frame_options] : []
        content {
          frame_option = frame_options.value.frame_option
          override     = frame_options.value.override
        }
      }

      dynamic "referrer_policy" {
        for_each = try(security_headers_config.value.referrer_policy, null) != null ? [security_headers_config.value.referrer_policy] : []
        content {
          referrer_policy = referrer_policy.value.referrer_policy
          override        = referrer_policy.value.override
        }
      }

      dynamic "strict_transport_security" {
        for_each = try(security_headers_config.value.strict_transport_security, null) != null ? [security_headers_config.value.strict_transport_security] : []
        content {
          access_control_max_age_sec = strict_transport_security.value.access_control_max_age_sec
          include_subdomains         = strict_transport_security.value.include_subdomains
          preload                    = strict_transport_security.value.preload
          override                   = strict_transport_security.value.override
        }
      }

      dynamic "xss_protection" {
        for_each = try(security_headers_config.value.xss_protection, null) != null ? [security_headers_config.value.xss_protection] : []
        content {
          protection = xss_protection.value.protection
          mode_block = xss_protection.value.mode_block
          report_uri = try(xss_protection.value.report_uri, null)
          override   = xss_protection.value.override
        }
      }

      dynamic "content_security_policy" {
        for_each = try(security_headers_config.value.content_security_policy, null) != null ? [security_headers_config.value.content_security_policy] : []
        content {
          content_security_policy = content_security_policy.value.content_security_policy
          override                = content_security_policy.value.override
        }
      }
    }
  }
}
