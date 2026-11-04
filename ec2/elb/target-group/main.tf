locals {
  health_check_protocol = upper(coalesce(var.health_check_protocol, var.tg_protocol))
  health_check_is_http  = contains(["HTTP", "HTTPS"], local.health_check_protocol)
}

resource "aws_lb_target_group" "altg" {
  name        = var.tg_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.tg_target_type

  health_check {
    path                = local.health_check_is_http ? var.health_check_path : null
    protocol            = local.health_check_protocol
    matcher             = local.health_check_is_http ? var.health_check_matcher : null
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    port                = var.health_check_port
  }

  tags = var.tags
}