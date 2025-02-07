terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"
    key            = "path/to/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-dynamodb-lock-table"
    encrypt        = true
  }
}
