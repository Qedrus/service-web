variable "environment" {
  description = "The environment tag for the S3 bucket"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "s3-bucket-name-2025-driss"
}

