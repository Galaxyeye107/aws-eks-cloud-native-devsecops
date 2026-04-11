############################################
# 1. Policy cho AWS Secrets Manager
############################################
resource "aws_iam_policy" "eks_secrets_policy" {
  name        = "EKSSecretsManagerPolicy"
  description = "Cho phep EKS doc secret tu Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:ap-southeast-1:837497587440:secret:prod/ecommerce/db-creds-*"
      }
    ]
  })
}

############################################
# 2. IAM Role cho Service Account (External Secrets)
############################################
module "allow_secrets_manager_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "eks-secrets-manager-role"

  role_policy_arns = {
    policy = aws_iam_policy.eks_secrets_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn

      # ⚠️ Đảm bảo SA này tồn tại trong cluster
      namespace_service_accounts = [
        "default:ecommerce-sa"
      ]
    }
  }
}

############################################
# 3. Policy cho AWS Load Balancer Controller
############################################
resource "aws_iam_policy" "lbc_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "Chinh sach cho AWS Load Balancer Controller trong EKS"

  # File JSON phải nằm cùng thư mục terraform
  policy = file("${path.module}/lbc_iam_policy.json")
}

############################################
# 4. IAM Role cho AWS Load Balancer Controller
############################################
module "lb_controller_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "eks-lb-controller-role"

  role_policy_arns = {
    policy = aws_iam_policy.lbc_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn

      namespace_service_accounts = [
        "kube-system:aws-load-balancer-controller"
      ]
    }
  }
}
# 5. Policy Cluster Autoscaler
resource "aws_iam_policy" "cluster_autoscaler" {
  name = "AmazonEKSClusterAutoscalerPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# 6. Gán Policy CA vào Node Group Role
resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attach" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = module.eks.eks_managed_node_groups["main"].iam_role_name
}
# 7. thêm ebs vào module aws_iam_role_policy_attachment cho EBS CSI Driver
module "ebs_csi_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "eks-ebs-csi-role"

  role_policy_arns = {
    policy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  oidc_providers = {
    main = {
      provider_arn = module.eks.oidc_provider_arn

      namespace_service_accounts = [
        "kube-system:ebs-csi-controller-sa"
      ]
    }
  }
}
