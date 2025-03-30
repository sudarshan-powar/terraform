terraform {
  backend "s3" {
    bucket         = "flixflow-terraform-backend"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "flixflow-lock-table"
    encrypt        = true
  }
}
