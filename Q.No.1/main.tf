resource "aws_iam_group_membership" "team" {
  name = "rubina-tf-testing-group-membership"

  users = [aws_iam_user.iam_rubina.name]

  group = aws_iam_group.iam_group.name
}

resource "aws_iam_user" "iam_rubina" {
  name = var.user
  path = "/system/"
}

resource "aws_iam_group" "iam_group" {
  name = var.group
  path = "/"
}

