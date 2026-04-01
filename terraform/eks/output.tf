output "secrets_manager_role_arn" {
  description = "ARN của IAM Role dành cho Service Account"
  value       = module.allow_secrets_manager_role.iam_role_arn
}
output "lb_controller_role_arn" {
  description = "ARN của IAM Role dành cho load banlancer controller"
  value       = module.lb_controller_role.iam_role_arn
}
output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}