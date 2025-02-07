#######################################
# Route 53 Zone Configuration
# This file defines the Route 53 hosted zone for the project.
#######################################

resource "aws_route53_zone" "project_hosted_zone" {
  name           = var.DOMAIN_NAME  # Domain name for the hosted zone
  force_destroy = var.FORCE_DESTROY  # If true, deletes all records when destroying the zone

  tags = {
    Terraform = "True"  # Identifies that this resource is managed by Terraform
  }
}
