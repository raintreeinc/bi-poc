resource "aws_secretsmanager_secret" "this" {
  name        = "${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-${lower(local.local_data.aws_team)}"
  description = "${local.local_data.aws_team} secrets"
  kms_key_id  = aws_kms_key.this.id
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(tomap({"Redshift User" = "${lower(local.local_data.tag_support_group)}user", "Redshift Password" = random_password.this.result, "Keypair" = aws_key_pair.this.key_name, "Public Key" = tls_private_key.this.public_key_openssh, "Private Key" = tls_private_key.this.private_key_pem, "AWS_ACCESS_KEY_ID" = local.access_key, "AWS_SECRET_ACCESS_KEY" = local.secret_key}))
  depends_on    = [
    aws_kms_key.this
  ]
}