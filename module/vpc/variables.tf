variable "project_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string

}

variable "enable_nat" {
  description = "Enable Nat for VPC"
  type        = bool
}

variable "nat_type" {
  description = "Type of NAT to use"
  type        = string
  default     = "gateway"
  validation {
    condition     = contains(["gateway", "instance"], var.nat_type)
    error_message = "Invalid NAT type. Please choose either 'gateway' or 'instance'."
  }
}

variable "nat_ebs_kms" {
  description = "KMS Id for Nat Volumn"
  type        = string
  default     = null

}

variable "nat_ebs_volumn" {
  description = "Volumn sixe of Nat instance"
  type        = number
  default     = 10
}

variable "nat_instance_key_pair" {
  description = "KMS Id for Nat Volumn"
  type        = string
  default     = "null"
}
variable "nat_instance_ami" {
  description = "Ami For Nat Instance"
  type        = string
  default     = null
}

variable "nat_instance_type" {
  description = "Instance Type of nat Instance"
  type        = string
  default     = "t3.micro"
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the VPC"
  type        = bool
  default     = false
}

variable "flow-log-bucket-retention-days" {
  description = "Numbers of days to keep flow log"
  type        = number
  default     = 15
}

variable "nat_instance_profile" {
  description = "IAM role for Nat Instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Define VPC tags"
  type        = map(string)
  default     = {}
}
