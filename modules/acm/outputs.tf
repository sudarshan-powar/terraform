# =============================================
# 📌 ACM Module Outputs
# =============================================

# ✅ ARN of the ACM certificate (used in CloudFront, ALB, etc.)
output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.project_domain.arn
}

# ✅ Primary domain name for the certificate
output "project_domain_name" {
  description = "The primary domain name associated with the ACM certificate"
  value       = aws_acm_certificate.project_domain.domain_name
}

# ✅ Validation status of the certificate
output "certificate_status" {
  description = "Current status of the ACM certificate (e.g., ISSUED, PENDING_VALIDATION)"
  value       = aws_acm_certificate.project_domain.status
}

# ✅ List of validation DNS records (useful for troubleshooting)
output "validation_dns_records" {
  description = "List of DNS validation records for ACM certificate"
  value       = [for record in aws_route53_record.validation_records : record.fqdn]
}

# ✅ Expiry date of the certificate (useful for renewal tracking)
output "certificate_expiry" {
  description = "Expiration date of the ACM certificate"
  value       = aws_acm_certificate.project_domain.not_after
}
