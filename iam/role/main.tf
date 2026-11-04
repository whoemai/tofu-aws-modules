resource "aws_iam_role" "air" {
  name                 = var.name
  assume_role_policy   = var.assume_role_policy
  max_session_duration = var.max_session_duration
  tags                 = var.tags
}
