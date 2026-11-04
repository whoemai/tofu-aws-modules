# Zips source_dir inline — nenhum build/zip externo necessário pra lambdas pequenas
# (código sem dependências de terceiros; se precisar de node_modules, gere-os antes e
# inclua no source_dir, ou use filename/s3_bucket+s3_key com um build de verdade).
data "archive_file" "source" {
  count       = var.source_dir != null ? 1 : 0
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/.archives/${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename          = var.source_dir != null ? data.archive_file.source[0].output_path : var.filename
  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version
  function_name     = var.function_name
  role              = var.role_arn
  handler           = var.handler
  runtime           = var.runtime
  timeout           = var.timeout
  memory_size       = var.memory_size
  architectures     = var.architectures

  environment {
    variables = var.environment_variables
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  # Prevent replacement when source code changes
  source_code_hash = (
    var.source_dir != null ? data.archive_file.source[0].output_base64sha256 :
    var.filename != null ? filebase64sha256(var.filename) :
    null
  )

  lifecycle {
    precondition {
      condition = length(compact([
        var.filename != null ? "f" : "",
        var.source_dir != null ? "d" : "",
        (var.s3_bucket != null && var.s3_key != null) ? "s" : "",
      ])) == 1
      error_message = "Provide exactly one of: filename, source_dir, or s3_bucket + s3_key."
    }
  }

  tags = var.tags
}

resource "aws_lambda_function_url" "this" {
  count              = var.function_url_config != null ? 1 : 0
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = var.function_url_config.authorization_type

  dynamic "cors" {
    for_each = try(var.function_url_config.cors, null) != null ? [var.function_url_config.cors] : []
    content {
      allow_origins = cors.value.allow_origins
      allow_methods = cors.value.allow_methods
      allow_headers = cors.value.allow_headers
      max_age       = try(cors.value.max_age, null)
    }
  }
}
