#######################################
# S3 Bucket Outputs
# This file defines the outputs for the S3 frontend bucket.
#######################################

output "s3_frontend_bucket_name" {
    value = aws_s3_bucket.frontend_bucket.id  # Outputs the S3 bucket name
}

output "s3_frontend_bucket_arn" {
  value = aws_s3_bucket.frontend_bucket.arn  # Outputs the Amazon Resource Name (ARN) of the S3 bucket
}

output "s3_frontend_bucket_domain" {
  value = aws_s3_bucket.frontend_bucket.bucket_domain_name  # Outputs the domain name of the S3 bucket
}

output "s3_frontend_bucket_id" {
  value = aws_s3_bucket.frontend_bucket.id  # Outputs the unique ID of the S3 bucket
}
