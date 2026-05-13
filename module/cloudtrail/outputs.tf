output "cloudtrail-arn" {

  description = "Cloudtrail ARN"
  value       = aws_cloudtrail.this.arn

}


output "cloudtrail-bucket-name" {

  description = "Cloudtrail bucket Name"
  value       = aws_s3_bucket.this.bucket

}

output "cloudtrail-bucket-arn" {

  description = "Cloudtrail Bucket ARN"
  value       = aws_s3_bucket.this.arn

}