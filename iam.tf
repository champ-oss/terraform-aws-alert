# tflint-ignore: terraform_comment_syntax
resource "aws_iam_role" "this" {
  count              = var.enabled ? 1 : 0
  name               = local.trimmed_name
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
  tags               = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

moved {
  from = module.this.aws_iam_role.this
  to   = aws_iam_role.this[0]
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

moved {
  from = module.this.data.aws_iam_policy_document.assume_role
  to   = data.aws_iam_policy_document.assume_role[0]
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

moved {
  from = module.this.aws_iam_role_policy_attachment.ssm
  to   = aws_iam_role_policy_attachment.ssm[0]
}

data "aws_iam_policy_document" "this" {
  count = var.enabled ? 1 : 0
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }
}

moved {
  from = module.this.data.aws_iam_policy_document.this
  to   = data.aws_iam_policy_document.this[0]
}

resource "aws_iam_policy" "this" {
  count       = var.enabled ? 1 : 0
  name_prefix = var.git
  policy      = data.aws_iam_policy_document.this[0].json
}

moved {
  from = module.this.aws_iam_policy.this
  to   = aws_iam_policy.this[0]
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.enabled ? 1 : 0
  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this[0].name
}

moved {
  from = module.this.aws_iam_role_policy_attachment.this
  to   = aws_iam_role_policy_attachment.this[0]
}
