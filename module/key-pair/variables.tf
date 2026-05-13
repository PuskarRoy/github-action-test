variable "key_pair_name" {
  description = "Key Pair Name"
  type        = string
}

variable "bucket_name" {
  description = "Bucket Name"
  type        = string
}

variable "tags" {
  description = "Define tags"
  type        = map(string)
  default     = {}
}