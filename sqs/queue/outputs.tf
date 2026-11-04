output "id" {
  description = "URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.sqs.id
}

output "arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.sqs.arn
}

output "url" {
  description = "Same as id: the URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.sqs.url
}

output "name" {
  description = "Name of the queue."
  value       = aws_sqs_queue.sqs.name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sqs_queue.sqs.tags_all
}
