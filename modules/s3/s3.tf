#######################################
# S3 Bucket Configuration
# This file defines the S3 bucket setup for frontend storage.
#######################################

resource "aws_s3_bucket" "frontend_bucket" {
  bucket              = var.S3_FRONTEND_BUCKET  # Name of the S3 bucket
  force_destroy       = var.S3_FRONTEND_BUCKET_FORCE_DESTROY  # Enables force deletion if true
  object_lock_enabled = var.S3_FRONTEND_BUCKET_OBJECT_LOCK  # Enables object lock if true

  tags = {
    Terraform = "True"  # Identifies that this resource is managed by Terraform
  }
}

#######################################
# S3 Ownership Controls
# Ensures that the bucket ownership is set to BucketOwnerPreferred.
#######################################

resource "aws_s3_bucket_ownership_controls" "s3_frontend_onwership" {
  bucket = aws_s3_bucket.frontend_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"  # Defines ownership rule for objects in the bucket
  }
}

#######################################
# S3 Public Access Block
# Blocks all public access to the S3 bucket to enhance security.
#######################################

resource "aws_s3_bucket_public_access_block" "s3_frontend_block" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = true  # Blocks new public ACLs
  block_public_policy     = true  # Prevents public bucket policies
  ignore_public_acls      = true  # Ignores any existing public ACLs
  restrict_public_buckets = true  # Restricts bucket from becoming public
}

#######################################
# S3 Versioning
# Enables versioning for the S3 bucket if configured.
#######################################

resource "aws_s3_bucket_versioning" "s3_frontend_versioning" {
  bucket = aws_s3_bucket.frontend_bucket.id
  versioning_configuration {
    status = var.S3_FRONTEND_BUCKET_VERSIONING  # Sets the versioning status (e.g., Enabled, Suspended)
  }
}
