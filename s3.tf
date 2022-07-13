resource "aws_s3_bucket" "this" {
  bucket                = "${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-${lower(local.local_data.aws_team)}"
  tags = {
    Name                = "${lower(local.local_data.aws_region_code)}-${lower(local.local_data.tag_env)}-${lower(local.local_data.aws_team)}"
  }
  lifecycle {
    ignore_changes = [
      server_side_encryption_configuration
    ]
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket                = aws_s3_bucket.this.id
  acl                   = "public-read-write"
}