output "id" {
  description = "S3 Bucket name"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "S3 Bucket ARN"
  value       = aws_s3_bucket.this.arn
}
