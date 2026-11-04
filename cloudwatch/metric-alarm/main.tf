resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm

  namespace          = var.namespace
  metric_name        = var.metric_name
  period             = var.period
  statistic          = var.statistic
  extended_statistic = var.extended_statistic
  threshold          = var.threshold
  dimensions         = var.dimensions
  unit               = var.unit
  treat_missing_data = var.treat_missing_data

  actions_enabled           = var.actions_enabled
  alarm_actions             = var.alarm_actions
  ok_actions                = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  alarm_description = var.alarm_description

  tags = var.tags
}
