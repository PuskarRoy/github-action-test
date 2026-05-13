resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.private_key.public_key_openssh
  tags       = var.tags
}

resource "aws_s3_object" "this" {
  bucket  = var.bucket_name
  key     = "credentials/${var.key_pair_name}.pem"
  content = tls_private_key.private_key.private_key_pem
}