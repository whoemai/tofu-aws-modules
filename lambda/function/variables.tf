variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "filename" {
  description = "Path to the Lambda function deployment package (.zip file). Use this OR s3_bucket/s3_key OR source_dir."
  type        = string
  default     = null
}

variable "source_dir" {
  description = "Path to a directory to zip inline via `archive_file` and deploy. Use this OR filename OR s3_bucket/s3_key — no external build/zip step needed."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing the Lambda deployment package. Use this with s3_key OR filename."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the Lambda deployment package. Use this with s3_bucket OR filename."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "S3 object version for the deployment package (optional)."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}

variable "handler" {
  description = "Lambda function entry point (e.g., 'lambda_handler.lambda_handler')"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime environment (e.g., 'python3.11', 'nodejs18.x')"
  type        = string
  default     = "python3.11"
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "Lambda function memory allocation in MB"
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}

variable "architectures" {
  description = "Lambda function architecture (x86_64 or arm64)"
  type        = list(string)
  default     = ["x86_64"]
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs for Lambda network interface"
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs for Lambda network interface"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Tags to apply to Lambda function"
  type        = map(string)
  default     = {}
}

variable "function_url_config" {
  description = "(Optional) - Creates a Lambda Function URL when set. `authorization_type` NONE = publicly invocable (fine for endpoints with no sensitive output, e.g. behind CloudFront); AWS_IAM requires the caller to sign the request (CloudFront needs OAC + a lambda/permission for lambda:InvokeFunctionUrl in that case, not handled by this module)."
  type = object({
    authorization_type = string
    cors = optional(object({
      allow_origins = optional(list(string), ["*"])
      allow_methods = optional(list(string), ["GET"])
      allow_headers = optional(list(string), [])
      max_age       = optional(number)
    }))
  })
  default = null
}
