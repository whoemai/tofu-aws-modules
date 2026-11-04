resource "aws_scheduler_schedule" "this" {
  name                         = var.name
  group_name                   = var.group_name
  description                  = var.description
  schedule_expression          = var.schedule_expression
  schedule_expression_timezone = var.schedule_expression_timezone
  state                        = var.state
  start_date                   = var.start_date
  end_date                     = var.end_date
  kms_key_arn                  = var.kms_key_arn
  action_after_completion      = var.action_after_completion

  flexible_time_window {
    mode                      = var.flexible_time_window_mode
    maximum_window_in_minutes = var.flexible_time_window_maximum_window_in_minutes
  }

  target {
    arn      = var.target_arn
    role_arn = var.target_role_arn
    input    = var.target_input

    retry_policy {
      maximum_event_age_in_seconds = var.retry_policy_maximum_event_age_in_seconds
      maximum_retry_attempts       = var.retry_policy_maximum_retry_attempts
    }

    dynamic "dead_letter_config" {
      for_each = var.dead_letter_arn == null ? [] : [var.dead_letter_arn]
      content {
        arn = dead_letter_config.value
      }
    }
  }
}
