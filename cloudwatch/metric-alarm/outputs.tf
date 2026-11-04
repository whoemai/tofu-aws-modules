output "arn" {
  description = "Amazon Resource Name of the CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.this.arn
}

output "id" {
  description = "ID of the CloudWatch alarm (its name)."
  value       = aws_cloudwatch_metric_alarm.this.id
}

output "alarm_name" {
  description = "Name of the CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.this.alarm_name
}
