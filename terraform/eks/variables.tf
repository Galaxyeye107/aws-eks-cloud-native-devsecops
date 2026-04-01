variable "aws_region" {
  description = "Region triển khai"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "Tên của EKS Cluster"
  type        = string
  default     = "devsecops-eks-cluster"
}

variable "tf_state_bucket" {
  description = "Bucket chứa state của VPC"
  type        = string
  default     = "trung-devsecops-eks-tfstate-prod"
}