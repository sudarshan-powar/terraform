# =============================================
# 📌 ACM Module Variables
# =============================================

# ✅ Domain name for ACM certificate
variable "DOMAIN_NAME" {
  description = "Domain name for ACM certificate"
  type        = string
}

# ✅ Alternative domain names (e.g., subdomains)
variable "ALTERNATIVE_NAMES" {
  description = "List of alternative domain names for the certificate"
  type        = list(string)
  default     = []
}

# ✅ Validation method (DNS or EMAIL)
variable "VALIDATION_METHOD" {
  description = "Validation method for ACM certificate (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

# ✅ Route 53 Hosted Zone ID for DNS validation
variable "R53_HOSTED_ZONE_ID" {
  description = "Route 53 Hosted Zone ID where the domain is managed"
  type        = string
}
