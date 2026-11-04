resource "aws_autoscaling_group" "asg" {

  name                      = var.name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = var.launch_template_id == null ? var.launch_configuration : null
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = var.target_group_arns

  dynamic "launch_template" {
    for_each = var.launch_template_id != null ? [1] : []
    content {
      id      = var.launch_template_id
      version = var.launch_template_version
    }
  }

  dynamic "tag" {
    for_each = var.tag
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }
}
