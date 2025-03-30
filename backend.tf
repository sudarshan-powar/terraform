terraform {
  backend "s3" {
    bucket         = "project-terraform-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "project-lock-table"
    encrypt        = true
  }
}
