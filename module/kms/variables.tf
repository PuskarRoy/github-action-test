variable "project_name" {
  description = "Name of the KMS Key"
  type        = string
}

variable "tags" {
  description = "Define tags"
  type        = map(string)
  default     = {}
}