variable "lb_name" {
  description = "name for target group"
  type        = string
}

variable "lb_access_log_bucket_id" {
  description = "Bucket For Alb Access Log"
  type        = string
}

variable "private" {
  description = "Weather ALB will public or private"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Type of Load Balancer"
  type        = string
  default     = "application"

  validation {
    condition = contains(
      ["application", "network"],
      var.lb_type
    )
    error_message = "Invalid lb_type. Allowed values: application, network."
  }
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the VPC"
  type        = bool
  default     = false
}

variable "lb_security_group_id" {
  description = "Security Group ID for LB"
  type        = string
}



variable "tags" {
  description = "S3 Bucket tags"
  type        = map(string)
  default     = {}
}

variable "lb_subnet_ids" {
  description = "List of subnet IDs for the Load Balancer"
  type        = list(string)

}