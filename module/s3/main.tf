resource "random_id" "s3_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket        = "${replace(lower(var.bucket_name), " ", "-")}-${lower(random_id.s3_suffix.hex)}"
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.bucket_versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.encryption-type == "aws:kms" ? var.kms_key_id : null
      sse_algorithm     = var.encryption-type
    }
    bucket_key_enabled       = true
    blocked_encryption_types = ["SSE-C"]
  }
}


