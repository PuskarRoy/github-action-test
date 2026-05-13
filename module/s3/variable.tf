variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "tags" {
  description = "S3 Bucket tags"
  type        = map(string)
  default     = {}
}

variable "bucket_versioning" {
  description = "Enable Bucket Versioning"
  type        = bool
  default     = false
}

variable "encryption-type" {
  type        = string
  description = "Bucket Encryption Type - SSE-S3 / SSE-KMS"
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.encryption-type)
    error_message = "Valid values : (AES256, aws:kms)."
  }
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key ID"
  default     = "aws/s3"
}