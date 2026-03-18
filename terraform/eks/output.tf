output "secrets_manager_role_arn" {
  description = "ARN của IAM Role dành cho Service Account"
  value       = module.allow_secrets_manager_role.iam_role_arn
}
# THÊM DÒNG NÀY VÀO ĐỂ DỄ DÀNG COPY ARN SAU NÀY
output "lb_controller_role_arn" {
  description = "ARN của IAM Role dành cho load banlancer controller"
  value       = module.lb_controller_role.iam_role_arn
}