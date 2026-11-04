variable "statement_id" {
  description = "(Required, Forces new resource) A unique statement identifier."
  type        = string
}

variable "function_name" {
  description = "(Required, Forces new resource) Name or ARN of the Lambda function."
  type        = string
}

variable "principal" {
  description = "(Required, Forces new resource) The principal who is getting this permission (e.g., apigateway.amazonaws.com)."
  type        = string
}

variable "source_arn" {
  description = "(Optional, Forces new resource) ARN of the source triggering the invocation, e.g. an API Gateway execution ARN."
  type        = string
  default     = null
}
