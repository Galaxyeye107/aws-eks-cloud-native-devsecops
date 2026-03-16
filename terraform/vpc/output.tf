# Đây là "bảng tin" công khai của VPC
output "vpc_id" {
  description = "ID của VPC để các dịch vụ khác (EKS, RDS) sử dụng"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Danh sách các Private Subnets để chạy EKS Nodes (Bảo mật)"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Danh sách các Public Subnets để đặt Load Balancer"
  value       = module.vpc.public_subnets
}