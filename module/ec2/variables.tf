variable "ami" {
  description = "The AMI ID of EC2"

}

variable "instance_type" {
  description = "The AMI ID of EC2"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID of EC2"
  type        = string
}

variable "elastic_ip" {
  description = "Whether you add elastic ip or not"
  type        = bool
}


variable "enable_instance_ipv6" {
  description = "Enable the Ipv6 address of ec2"
  type        = bool
  default     = false
}

variable "instance_profile" {
  description = "value"
  type        = string
  default     = null
}

variable "key_pair_name" {
  description = "Key Pair name of ec2"
  type        = string
}

variable "security_group_id" {
  description = "Security group id of Ec2"
  type        = string
}

variable "user_data" {
  description = "User Data File Path"
  type        = string
  default     = null
}

variable "root_volumn_size" {
  description = "Root Volumn Size of EC2"
  type        = number
}

variable "kms_key_id" {
  description = "KMS key Id"
  type        = string
}

variable "tags" {
  description = "tags of ec2"
  type        = map(string)
  default     = {}
}
