# =====================================================
# 🚀 CloudFront Input Variables
# =====================================================
# These variables define the configuration for the CloudFront distribution.
# =====================================================

# 🏠 Origin Settings
variable "ORIGIN_DOMAIN_NAME" {
  description = "The domain for routing requests to the origin (e.g., S3, ALB, API Gateway, etc.)."
  type        = string
}

variable "ORIGIN_ACCESS_CONTROL_ID" {
  description = "The ID for Origin Access Control (OAC) required for CloudFront Distribution."
  type        = string
}

variable "ORIGIN_ID" {
  description = "Unique identifier for the CloudFront origin."
  type        = string
}

# ✅ CloudFront Basic Settings
variable "CLOUDFRONT_ENABLE" {
  description = "Enable or disable the CloudFront distribution."
  type        = bool
  default     = true
}

variable "CLOUDFRONT_IPV6" {
  description = "Enable IPv6 support for CloudFront."
  type        = bool
  default     = true
}

variable "CLOUDFRONT_DEFAULT_ROOT_OBJECT" {
  description = "Default root object to serve when no specific file is requested (e.g., index.html)."
  type        = string
  default     = "index.html"
}

# 🌎 Logging Configuration (Optional)
variable "CLOUDFRONT_LOGS_BUCKET" {
  description = "S3 bucket where CloudFront access logs will be stored. If left empty, logging is disabled."
  type        = string
  default     = ""
}

# 🔗 Aliases (Custom Domains)
variable "CLOUDFRONT_ALIASES" {
  description = "List of custom domain names (CNAMEs) for the CloudFront distribution."
  type        = list(string)
  default     = []
}

# 🔥 Cache Behavior
variable "CLOUDFRONT_ALLOWED_METHODS" {
  description = "List of HTTP methods allowed by CloudFront (e.g., GET, POST, PUT, DELETE, HEAD, OPTIONS, PATCH)."
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "CLOUDFRONT_CACHED_METHODS" {
  description = "List of HTTP methods that CloudFront should cache (usually GET and HEAD)."
  type        = list(string)
  default     = ["GET", "HEAD"]
}

# 🎯 Query String and Cookie Handling
variable "CLOUDFRONT_QUERY_STRING" {
  description = "Whether CloudFront should forward query strings to the origin."
  type        = bool
  default     = false
}

variable "CLOUDFRONT_COOKIES_FORWARD" {
  description = "Determines how CloudFront handles cookies. Options: 'none', 'all', or specify selected cookies."
  type        = string
  default     = "none"
}

# 🔑 SSL/TLS Configuration
variable "ACM_CERTIFICATE_ARN" {
  description = "ARN of the ACM certificate used for enabling HTTPS on CloudFront."
  type        = string
}

variable "SSL_SUPPORT_METHOD" {
  description = "Method used for SSL/TLS support. Options: 'sni-only' or 'vip'."
  type        = string
  default     = "sni-only"
}

variable "MIN_PROTOCOL_VERSION" {
  description = "Minimum TLS version that CloudFront should support for HTTPS connections."
  type        = string
  default     = "TLSv1.2_2021"
}

# 🌍 Route 53 Domain Aliases
variable "ALTERNATIVE_ALIAS_RECORD_DOMAIN" {
  description = "Alternative domain alias (e.g., www.example.com) for CloudFront in Route 53."
  type        = string
}

variable "ALIAS_RECORD_DOMAIN" {
  description = "Primary domain alias (e.g., example.com) for CloudFront in Route 53."
  type        = string
}

variable "HOSTED_ZONE_ID" {
  description = "The ID of the Route 53 Hosted Zone where CloudFront aliases will be created."
  type        = string
}

# 🌎 Geographic Restrictions
variable "RESTRICTION_TYPE" {
  description = "Defines whether CloudFront restricts access to specific regions or countries."
  type        = string
  default     = "none"
}

variable "RESTRICTED_LOCATIONS" {
  description = "List of locations (ISO 3166-1 alpha-2 country codes) to restrict access if RESTRICTION_TYPE is set."
  type        = list(string)
  default     = []
}

# 🌐 Viewer Protocol Policy
variable "VIEWER_PROTOCOL_POLICY" {
  description = "Controls whether viewers can use HTTP or must use HTTPS."
  type        = string
  default     = "allow-all"
}

# 💰 Cost and Performance Optimization
variable "CLOUDFRONT_PRICECLASS" {
  description = "Defines the price class for CloudFront (e.g., PriceClass_100, PriceClass_200, or PriceClass_All)."
  type        = string
  default     = "PriceClass_All"
}
