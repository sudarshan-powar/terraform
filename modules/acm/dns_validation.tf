# =============================================
# ✅ Route 53 DNS Validation Records
# =============================================
# Creates DNS records required for domain validation in AWS ACM
resource "aws_route53_record" "validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.project_domain.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record] # DNS validation records
  ttl             = 60                  # Time-to-live for the DNS record
  type            = each.value.type
  zone_id         = var.R53_HOSTED_ZONE_ID # Hosted Zone ID for DNS validation
}
