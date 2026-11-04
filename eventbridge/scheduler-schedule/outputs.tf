output "id" {
  value       = aws_scheduler_schedule.this.id
  description = "Name of the schedule, prefixed by its group (<group>/<name>)."
}

output "arn" {
  value       = aws_scheduler_schedule.this.arn
  description = "ARN of the schedule."
}
