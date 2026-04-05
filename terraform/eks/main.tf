# Lấy thông tin VPC từ Remote State
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "vpc/terraform.tfstate"
    region = var.aws_region
  }
}

# Tạo KMS Key để mã hóa Kubernetes Secrets (Yêu cầu bảo mật cao)
resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true # Best practice
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "devsecops-eks-cluster"
  cluster_version = "1.31"

  # Bảo mật: Cho phép truy cập nội bộ và giới hạn public (Cấu hình demo)
  cluster_endpoint_public_access = true

  # Cấu hình mạng từ VPC bài trước
  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.vpc.outputs.private_subnets
  control_plane_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  # Bật KMS Encryption cho Secrets
  create_kms_key = false
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks.arn
  }

  # Bật Logging để điều tra khi có sự cố (Audit logs)
  cluster_enabled_log_types = ["audit", "api", "authenticator"]

  # Managed Node Group (Worker Nodes)
  eks_managed_node_groups = {
    main = {
      min_size       = 1
      max_size       = 5
      desired_size   = 4            # Cấu hình đủ để chạy lab.
      instance_types = ["t3.small"] # Đủ để chạy lab, đừng dùng t3.micro vì sẽ thiếu RAM
      capacity_type  = "ON_DEMAND"  # tài khoản free tier không có spot instance, nếu có thể thì dùng SPOT để tiết kiệm chi phí
      tags = {
        "k8s.io/cluster-autoscaler/enabled"             = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
      }
    }
  }
  # Tạo OIDC Provider để dùng IRSA (Rất quan trọng cho DevSecOps)
  enable_irsa = true
  # Quản lý quyền truy cập bằng aws-auth (Cơ chế của v19)
  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::837497587440:user/trung_devsecops" # ARN của bạn
      username = "admin-user"
      groups   = ["system:masters"] # Cấp quyền tối cao trong K8s
    }
  ]
  # Quan trọng: cho creator admin quyền cluster
}
# 2. Cài Metrics Server bằng Helm chart
resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

  force_update    = true # Ép buộc cập nhật nếu đã tồn tại
  cleanup_on_fail = true # Tự dọn dẹp nếu cài lỗi

  set = [
    {
      name  = "args"
      value = "{--kubelet-insecure-tls}" # Cần thiết cho một số môi trường EKS đặc thù
    }
  ]

  depends_on = [module.eks]
}
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = module.eks.cluster_name
    },
    {
      name  = "awsRegion"
      value = var.aws_region
    },
    {
      name  = "cloudProvider"
      value = "aws"
    }
  ]

  depends_on = [module.eks]
}