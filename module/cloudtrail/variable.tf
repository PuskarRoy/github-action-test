variable "tags" {
  description = "Cloudtrail Tags"
  type        = map(string)
  default     = {}
}

variable "project_name" {
  description = "Name of the Cloudtrail"
  type        = string
}

variable "cloudtrail-bucket-retention-days" {
  description = "Number of days to keep Cloudtrail log"
  type        = number
  default     = 365
}