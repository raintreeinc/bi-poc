data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "DenyVPC" {
  name = "DenyVPC"
}

resource "aws_iam_role" "this" {
  name                = "rt-redshift-${lower(local.local_data.aws_team)}"
  path                = "/system/"
  assume_role_policy  = data.aws_iam_policy_document.this.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  ]
  tags = {
    Name = "rt-ec2-${lower(local.local_data.aws_team)}"
  }
}

resource "aws_iam_instance_profile" "this" {
  name  = "rt-redshift-${lower(local.local_data.aws_team)}"
  role  = aws_iam_role.this.name
}

resource "aws_iam_user" "this" {
  name        = "${upper(local.local_data.aws_region_code)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  path        = "/"
}

data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group" "this" {
  name        = "${upper(local.local_data.aws_region_code)}-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
}

resource "aws_iam_group_policy_attachment" "this" {
  group       = aws_iam_group.this.name
  policy_arn  = data.aws_iam_policy.this.arn
}

resource "aws_iam_group_policy_attachment" "DenyVPC" {
  group       = aws_iam_group.this.name
  policy_arn  = data.aws_iam_policy.DenyVPC.arn
}

resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
}