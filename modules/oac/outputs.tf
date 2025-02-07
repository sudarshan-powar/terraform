# =====================================================
# 📤 AWS CloudFront OAC Outputs
# =====================================================
# These outputs expose useful attributes for other modules.
# =====================================================

# 🆔 OAC ID
output "oac_id" {
  description = "The ID of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.oac.id
}

# 🏷️ OAC Name
output "oac_name" {
  description = "The Name of the CloudFront Origin Access Control"
  value       = aws_cloudfront_origin_access_control.oac.name
}
