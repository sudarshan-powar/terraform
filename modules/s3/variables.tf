#######################################
# S3 Bucket Variables
# This file defines the input variables for the S3 frontend bucket.
#######################################

variable "S3_FRONTEND_BUCKET" {
  description = "Name of the S3 frontend bucket"  # Specifies the name of the S3 bucket
  type = string
}

variable "S3_FRONTEND_BUCKET_VERSIONING" {
  description = "Enable or disable bucket versioning"  # Controls versioning status (e.g., Enabled, Disabled)
  type = string
  default = "Disabled"
}

variable "S3_FRONTEND_BUCKET_FORCE_DESTROY" {
  description = "This will destroy the buckets even if it is not empty"  # If true, allows bucket deletion with objects inside
  type = bool
  default = false
}

variable "S3_FRONTEND_BUCKET_OBJECT_LOCK" {
  description = "This will lock the objects of the buckets"  # Enables object lock for compliance and security
  type = bool
  default = false
}

variable "CLOUDFRONT_DISTRIBUTION_ARN" {
  description = "This is ARN of CloudFront Distribution from CloudFront module"  # Used for linking CloudFront to the S3 bucket
  type = string
}
