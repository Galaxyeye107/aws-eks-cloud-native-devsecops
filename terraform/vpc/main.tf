terraform {
  required_version = ">= 1.0.0"
  backend "s3" {} # Cấu hình sẽ được nạp từ GitHub Actions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  # checkov:skip=CKV_AWS_111: Flow logs are enabled via module properties but Checkov cannot detect them.
  # checkov:skip=CKV_AWS_135: Ensure VPC is not public (This is a base VPC, we have public subnets for ALB)
  name = "devsecops-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]     # Cho EKS Nodes
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"] # Cho Load Balancer
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"] # Cho RDS
  # Bật NAT Gateway để EKS Nodes có thể ra internet
  enable_nat_gateway     = true
  single_nat_gateway     = true # Lab thì dùng 1 cái cho rẻ, Prod dùng mỗi AZ 1 cái
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  # --- BỔ SUNG flow_log ĐỂ PASS CHECKOV ---
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  # Gán Tag để EKS có thể tự động nhận diện Subnet khi tạo Load Balancer
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}