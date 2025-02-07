# =====================================================
# 🚀 CloudFront Outputs
# =====================================================
# These outputs will allow referencing CloudFront properties 
# in other modules or Terraform configurations.
# =====================================================

# CloudFront Distribution ID
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.project_cdn.id
}

# CloudFront Domain Name (used to access the distribution)
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.project_cdn.domain_name
}

# CloudFront ARN (Amazon Resource Name)
output "cloudfront_domain_arn" {
  value = aws_cloudfront_distribution.project_cdn.arn
}
