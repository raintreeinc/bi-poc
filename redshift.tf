data "aws_security_group" "this" {
  name  = "${lower(local.local_data.aws_region_code)}-sg-${lower(local.local_data.tag_env)}-redshift-public-inbound"
}

resource "aws_redshift_cluster" "this" {
  cluster_identifier        = "${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-${lower(local.local_data.aws_team)}"
  database_name             = "${lower(local.local_data.tag_support_group)}_${lower(local.local_data.tag_env)}"
  master_username           = "${lower(local.local_data.tag_support_group)}user"
  master_password           = random_password.this.result
  cluster_public_key        = tls_private_key.this.public_key_openssh
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  cluster_subnet_group_name = "${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-redshift-public"
  vpc_security_group_ids   = [
    data.aws_security_group.this.id
  ]
  encrypted                 = true
  iam_roles                 = [
    aws_iam_role.this.arn
  ]
  kms_key_id                = aws_kms_key.this.arn
  depends_on                = [
    random_password.this,
    aws_iam_role.this,
    tls_private_key.this
  ]
}