output "arn" {
  description = "ARN of the ALB"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "DNS name of the LB"
  value       = aws_lb.this.dns_name
}