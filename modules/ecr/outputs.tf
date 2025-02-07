# =====================================================
# 📤 ECR Outputs
# =====================================================
# These outputs expose key details of the created ECR repository,
# allowing other modules to reference them easily.
# =====================================================


# MAIN ECR REPOSITORY
output "ecr_repo_id" {
  description = "The ID of the ECR repository"
  value       = aws_ecr_repository.ecr.id
}

output "ecr_repo_arn" {
  description = "The Amazon Resource Name (ARN) of the ECR repository"
  value       = aws_ecr_repository.ecr.arn
}

output "ecr_repo_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.ecr.name
}


# CERT-MANAGER CAINJECTOR
output "cainjector_repo_id" {
  description = "The ID of the ECR repository"
  value       = aws_ecr_repository.cainjector_repo.id
}

output "cainjector_repo_arn" {
  description = "The Amazon Resource Name (ARN) of the ECR repository"
  value       = aws_ecr_repository.cainjector_repo.arn
}

output "cainjector_repo_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.cainjector_repo.name
}


# CERT-MANAGER CONTROLLER
output "controller_repo_id" {
  description = "The ID of the ECR repository"
  value       = aws_ecr_repository.controller_repo.id
}

output "controller_repo_arn" {
  description = "The Amazon Resource Name (ARN) of the ECR repository"
  value       = aws_ecr_repository.controller_repo.arn
}

output "controller_repo_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.controller_repo.name
}



# CERT-MANAGER WEBHOOK
output "webhook_repo_id" {
  description = "The ID of the ECR repository"
  value       = aws_ecr_repository.webhook_repo.id
}

output "webhook_repo_arn" {
  description = "The Amazon Resource Name (ARN) of the ECR repository"
  value       = aws_ecr_repository.webhook_repo.arn
}

output "webhook_repo_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.webhook_repo.name
}
