variable "database_Name" {
  description = "Name of the database identifier"
  type        = string
}
variable "subnets" {
  description = "List of subnets to create subnet group"
  type        = list(string)
}

variable "port" {
  description = "Port of Database Instance"
  type        = number
  default     = null
}

variable "engine" {
  description = "Engine Type"
  type        = string
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = null
}


variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "kms_key_id" {
  description = "KMS Key ID"
  type        = string
}

variable "apply_immediately" {
  description = "whether database modifications are applied immediately"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Should multi-az enable or not"
  type        = bool
  default     = false
}

variable "storage" {
  description = "size for database"
  type        = number
}

variable "backup_retention_period" {
  description = "The days to retain backups"
  type        = number
  default     = 0
}

variable "backup_window" {
  description = "Backup Window"
  type        = string
  default     = "18:30-20:30"
}

variable "skip_final_snapshot" {
  description = "whether final snapshot enable or not"
  type        = bool
  default     = true
}

variable "iam_database_authentication_enabled" {
  description = "whether enable IAM Auth in database"
  type        = bool
  default     = false
}

variable "max_allocated_storage" {
  description = "Storage Autoscaling"
  type        = number
  default     = 0
}

# variable "maintenance_window" {
#   description = "value"
#   type        = string
#   default     = "null"
# }

variable "monitoring_interval" {
  description = "Enhanced Monitoring metrics"
  type        = number
  default     = 0
}

variable "network_type" {
  description = "The network type of the DB instance."
  type        = string
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "DUAL"], var.network_type)
    error_message = "The network_type must be either 'IPV4' or 'DUAL'."
  }
}

variable "storage_type" {
  description = "The Storage Type of Database Instance"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "The storage_type must be one of: standard, gp2, gp3, io1, or io2."
  }
}

variable "security_group_id" {
  description = "Security Group Of RDS"
  type        = string
}

variable "tags" {
  description = "Define VPC tags"
  type        = map(string)
  default     = {}
}
