# =============================================
# ✅ ACM Certificate Validation
# =============================================
# Ensures that the ACM certificate gets validated
resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = aws_acm_certificate.project_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.validation_records : record.fqdn]
}
