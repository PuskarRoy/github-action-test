variable "vpc_id" {
  description = "VPC ID for Target Group"
  type        = string
}


variable "tg_name" {
  description = "name for target group"
  type        = string
}

variable "tg_port" {
  description = "Port on which targets receive traffic"
  type        = number
}

variable "tg_protocol" {
  description = "Protocol to use for routing traffic to the targets"
  type        = string

  validation {
    condition = (
      var.tg_target_type == "lambda" ||
      contains(
        ["GENEVE", "HTTP", "HTTPS", "TCP", "TCP_UDP", "TLS", "UDP", "QUIC", "TCP_QUIC"],
        var.tg_protocol
      )
    )
    error_message = "Invalid protocol. Allowed values: GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, UDP, QUIC, TCP_QUIC. Protocol is not required when target_type is lambda."
  }
}

variable "enable_stickiness" {
  description = "Weather to enable stickiness"
  type        = bool
  default     = false
}

variable "tg_target_type" {
  description = "Target type for the target group (instance, ip, lambda, alb)"
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip", "lambda", "alb"], var.tg_target_type)
    error_message = "Invalid target_type. Allowed values: instance, ip, lambda, alb."
  }
}

variable "tags" {
  description = "S3 Bucket tags"
  type        = map(string)
  default     = {}
}

variable "tg_targets" {
  description = "Targets Arns for target group"
  type        = list(string)
}
