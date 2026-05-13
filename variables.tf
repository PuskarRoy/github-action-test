# #####################################################################
# #      ---VPC---
# #####################################################################
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Name of the VPC"
  type        = string
}

# variable "vpc_cidr" {
#   description = "VPC CIDR"
#   type        = string

# }

# variable "enable_nat" {
#   description = "Enable Nat for VPC"
#   type        = bool
# }

# variable "enable_ipv6" {
#   description = "Enable IPv6 for the VPC"
#   type        = bool
# }

# #####################################################################
# #        ---EC2---
# #####################################################################

# variable "ami" {
#   description = "AMI ID for EC2 instances"
#   type        = string
# }
# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
# }

# variable "instance_ipv6" {
#   description = "Associate ipv6 with EC2 instance"
#   type        = string
# }

# variable "instance_profile" {
#   description = "Name of Instance Profile"
#   type        = string
# }

# variable "source_dest_check" {
#   description = "Source Destination Check"
#   type        = bool
#   default     = true
# }

# variable "subnet_id" {
#   description = "Subnet ID"
#   type        = string
# }

# variable "user_data" {
#   description = "Destination of User Data File"
#   type        = string
# }

# variable "root_volumn_size" {
#   description = "Destination of User Data File"
#   type        = string
# }

# variable "vpc_security_group_id" {
#   description = "Security Group Id of Ec2"
#   type        = string
# }

# variable "tags" {
#   description = "Tags for Ec2"
#   type        = map(string)
# }

# variable "key_pair_name" {
#   description = "Key Pair Name"
#   type        = string
# }