output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "role_arn" {
  description = "IAM role ARN used by Lambda"
  value       = var.role_arn
}

output "function_url" {
  description = "Function URL (null se function_url_config não foi setado)"
  value       = try(aws_lambda_function_url.this[0].function_url, null)
}

output "function_url_domain" {
  description = "Domain name da Function URL, sem https:// — pronto pra usar como `domain_name` de uma origin custom no cloudfront-distribution (null se function_url_config não foi setado)"
  value       = try(trimsuffix(trimprefix(aws_lambda_function_url.this[0].function_url, "https://"), "/"), null)
}
