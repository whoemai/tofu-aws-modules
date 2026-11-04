resource "aws_iam_user" "user" {
  name = var.name
  path = var.path

  tags = var.tags
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}
