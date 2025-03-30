#######################################
# S3 Bucket Policy
# This file defines the policy to allow CloudFront access to the S3 bucket.
#######################################

resource "aws_s3_bucket_policy" "oac_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id # Associates the policy with the S3 bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend_bucket.arn}/*" # Grants read access to CloudFront
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.CLOUDFRONT_DISTRIBUTION_ARN # Restricts access to CloudFront distribution
          }
        }
      }
    ]
  })
}
