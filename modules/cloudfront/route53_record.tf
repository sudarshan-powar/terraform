# =====================================================
# 🌍 AWS Route 53 Record Configuration
# =====================================================
# This module creates Route 53 records to associate the CloudFront distribution
# with a custom domain. It includes:
# - A root domain record (e.g., example.com)
# - A wildcard subdomain record (e.g., *.example.com)
# =====================================================

# ===============================
# 🔗 Root Domain Record (A Record)
# ===============================
# This record points the root domain (e.g., example.com) to the CloudFront distribution.
resource "aws_route53_record" "root_domain" {
  zone_id = var.HOSTED_ZONE_ID       # Route 53 Hosted Zone ID
  name    = var.ALIAS_RECORD_DOMAIN  # Primary domain (e.g., example.com)
  type    = "A"                      # A Record for IPv4 address resolution

  alias {
    name                   = aws_cloudfront_distribution.project_cdn.domain_name   # CloudFront domain
    zone_id                = aws_cloudfront_distribution.project_cdn.hosted_zone_id # CloudFront hosted zone
    evaluate_target_health = false # No health checks needed since CloudFront is a global service
  }
}

# ===============================
# 🔗 Wildcard Subdomain Record (A Record)
# ===============================
# This record allows all subdomains (*.example.com) to also route through CloudFront.
resource "aws_route53_record" "www_subdomain" {
  zone_id = var.HOSTED_ZONE_ID                    # Route 53 Hosted Zone ID
  name    = var.ALTERNATIVE_ALIAS_RECORD_DOMAIN  # Wildcard subdomain (e.g., www.example.com)
  type    = "A"                                   # A Record for IPv4 address resolution

  alias {
    name                   = aws_cloudfront_distribution.project_cdn.domain_name   # CloudFront domain
    zone_id                = aws_cloudfront_distribution.project_cdn.hosted_zone_id # CloudFront hosted zone
    evaluate_target_health = false # No health checks needed
  }
}