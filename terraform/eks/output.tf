output "secrets_manager_role_arn" {
  description = "ARN của IAM Role dành cho Service Account"
  value       = module.allow_secrets_manager_role.iam_role_arn
}