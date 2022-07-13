resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "this" {
  key_name = "KP-${upper(local.local_data.tag_env)}-${upper(local.local_data.aws_team)}"
  public_key = tls_private_key.this.public_key_openssh
}