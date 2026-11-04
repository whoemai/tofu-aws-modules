resource "aws_iam_policy" "aip" {
  name        = var.name
  path        = var.path
  description = var.description
  policy      = var.policy
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = var.role_name == null ? 0 : 1
  role       = var.role_name
  policy_arn = aws_iam_policy.aip.arn
}

resource "aws_iam_user_policy_attachment" "attach_user" {
  count      = var.user_name == null ? 0 : 1
  user       = var.user_name
  policy_arn = aws_iam_policy.aip.arn
}