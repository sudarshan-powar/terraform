#######################################
# Route 53 Outputs
# This file defines the outputs for the Route 53 module.
#######################################

output "hosted_zone_arn" {
  value = aws_route53_zone.project_hosted_zone.arn  # ARN of the hosted zone
}

output "hosted_zone_id" {
  value = aws_route53_zone.project_hosted_zone.id  # Unique ID of the hosted zone
}
