# =====================================================
# 🚀 AWS CloudFront Distribution Configuration
# =====================================================
# This module provisions an AWS CloudFront distribution to act as 
# a Content Delivery Network (CDN) for serving static and dynamic content efficiently.
# It caches content at AWS edge locations to improve performance and reduce latency.
# =====================================================

resource "aws_cloudfront_distribution" "project_cdn" {

  # ===============================
  # 🌎 Define CloudFront Origin
  # ===============================
  # The origin is the backend source of the content served by CloudFront.
  # This can be an S3 bucket, ALB, or API Gateway.
  origin {
    domain_name              = var.ORIGIN_DOMAIN_NAME       # The domain name of the origin
    origin_access_control_id = var.ORIGIN_ACCESS_CONTROL_ID # The OAC ID for security (S3/ALB)
    origin_id                = var.ORIGIN_ID                # A unique identifier for the origin
  }

  # ===============================
  # ⚙️ CloudFront Configuration
  # ===============================
  enabled             = var.CLOUDFRONT_ENABLE              # Enable or disable CloudFront distribution
  is_ipv6_enabled     = var.CLOUDFRONT_IPV6                # Enable IPv6 for better performance
  comment             = "Project's home URL"               # CloudFront distribution description
  default_root_object = var.CLOUDFRONT_DEFAULT_ROOT_OBJECT # Default object to load (e.g., index.html)

  # ===============================
  # 📜 Logging Configuration (Optional)
  # ===============================
  # CloudFront can log requests to an S3 bucket for auditing & troubleshooting.
  # Uncomment this block and provide a valid log bucket to enable logging.
  # logging_config {
  #   include_cookies = var.CLOUDFRONT_COOKIES_ENABLED  # Log requests including cookies
  #   bucket          = var.CLOUDFRONT_LOGS_BUCKET      # S3 bucket to store logs
  #   prefix          = "myprefix"                      # Prefix for log files
  # }

  # ===============================
  # 🔗 CloudFront Aliases (Custom Domains)
  # ===============================
  # These aliases allow the CloudFront distribution to be accessed using a custom domain.
  aliases = var.CLOUDFRONT_ALIASES # List of custom domains (e.g., example.com)

  # ===============================
  # 🔥 Default Cache Behavior
  # ===============================
  # Defines how CloudFront caches and serves content.
  default_cache_behavior {
    allowed_methods  = var.CLOUDFRONT_ALLOWED_METHODS # HTTP methods allowed for caching
    cached_methods   = var.CLOUDFRONT_CACHED_METHODS  # HTTP methods to be cached
    target_origin_id = var.ORIGIN_ID                  # Link behavior to the origin

    # ===============================
    # 🎯 Forwarding Configuration
    # ===============================
    # Controls how CloudFront handles query strings and cookies.
    forwarded_values {
      query_string = var.CLOUDFRONT_QUERY_STRING # Whether to forward query strings

      cookies {
        forward = var.CLOUDFRONT_COOKIES_FORWARD # Control how cookies are handled
      }
    }

    viewer_protocol_policy = var.VIEWER_PROTOCOL_POLICY # Enforce HTTPS or allow HTTP
    min_ttl                = 0                          # Minimum cache TTL (Time To Live)
    default_ttl            = 3600                       # Default cache TTL
    max_ttl                = 86400                      # Maximum cache TTL
  }

  # ===============================
  # 💰 Pricing Class
  # ===============================
  # Defines which CloudFront edge locations will be used to serve content.
  # Lower pricing classes reduce costs but limit global distribution.
  price_class = var.CLOUDFRONT_PRICECLASS

  # ===============================
  # 🌎 Geo-Restrictions (Optional)
  # ===============================
  # Restrict access to specific locations or allow global access.
  restrictions {
    geo_restriction {
      restriction_type = var.RESTRICTION_TYPE     # Options: "none", "whitelist", "blacklist"
      locations        = var.RESTRICTED_LOCATIONS # List of allowed/restricted countries
    }
  }

  # ===============================
  # 🔑 SSL/TLS Configuration
  # ===============================
  # Configures SSL/TLS certificates and security policies.
  viewer_certificate {
    acm_certificate_arn      = var.ACM_CERTIFICATE_ARN  # ACM SSL certificate for HTTPS
    ssl_support_method       = var.SSL_SUPPORT_METHOD   # SSL validation method
    minimum_protocol_version = var.MIN_PROTOCOL_VERSION # TLS security policy
  }

  # ===============================
  # 🏷️ Tags for Resource Management
  # ===============================
  tags = {
    Terraform = "True" # Identifies this resource as managed by Terraform
  }
}
