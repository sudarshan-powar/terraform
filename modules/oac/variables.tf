# =====================================================
# 📌 AWS CloudFront OAC Variables
# =====================================================
# These variables define how CloudFront interacts with the origin securely.
# =====================================================

# 🏷️ OAC Name
variable "ORIGIN_ACCESS_CONTROL_NAME" {
  description = "Name of Origin Access Control (OAC)"
  type        = string
}

# 🏠 Origin Type
variable "OAC_TYPE" {
  description = "Type of Origin Access Control (S3, Custom, etc.)"
  type        = string
  default     = "s3"
}

# 🔑 Signing Behavior
variable "OAC_SIGNING_BEHAVIOR" {
  description = "Defines when CloudFront signs requests to the origin"
  type        = string
  default     = "always"
}

# 🔐 Signing Protocol
variable "OAC_SIGNING_PROTOCOL" {
  description = "Defines the signing protocol for CloudFront"
  type        = string
  default     = "sigv4"
}
