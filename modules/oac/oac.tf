# =====================================================
# 🚀 AWS CloudFront Origin Access Control (OAC) 
# =====================================================
# This resource configures an OAC to securely connect CloudFront to S3 or another origin.
# =====================================================

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.ORIGIN_ACCESS_CONTROL_NAME # OAC Name
  description                       = "Project Policy"               # Description for clarity
  origin_access_control_origin_type = var.OAC_TYPE                   # Origin type (e.g., S3)
  signing_behavior                  = var.OAC_SIGNING_BEHAVIOR       # Determines when signing occurs
  signing_protocol                  = var.OAC_SIGNING_PROTOCOL       # Defines the signing protocol
}
