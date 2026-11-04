resource "aws_cloudwatch_event_target" "aet" {
  target_id = var.target_id
  rule      = var.rule
  arn       = var.arn

  dynamic "run_command_targets" {
    for_each = var.run_command_targets == null ? [] : var.run_command_targets
    content {
      key    = run_command_targets.value.key
      values = run_command_targets.value.values
    }
  }
}
