output "vpc-id" {
  description = "ID of the VPC"
  value       = aws_vpc.main-vpc.id
}

output "vpc-cidr_block" {
  description = "CIDR block of VPC"
  value       = aws_vpc.main-vpc.cidr_block
}

output "vpc-cidr_block_ipv6" {
  description = "IPV6 CIDR Block of VPC"
  value       = var.enable_ipv6 ? aws_vpc.main-vpc.ipv6_cidr_block : null
}

output "public_subnets_ids" {
  description = "Public subnets cidr"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnets_ids" {
  description = "Private subnets cidr"
  value       = aws_subnet.private_subnets[*].id
}

output "vpc-flow-log-Destination" {
  description = "VPC Flow Log Destination"
  value       = aws_flow_log.this.log_destination
}
