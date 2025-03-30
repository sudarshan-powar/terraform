# =============================================
# ✅ ACM Certificate for Domain & Validation
# =============================================

# 🚀 Creates an ACM certificate for the specified domain
resource "aws_acm_certificate" "project_domain" {
  domain_name               = var.DOMAIN_NAME       # Primary domain for SSL
  validation_method         = var.VALIDATION_METHOD # Method of validation (DNS/Email)
  subject_alternative_names = var.ALTERNATIVE_NAMES # Additional domain names

  tags = {
    Terraform = "True" # Tag to identify Terraform-managed resources
  }
}