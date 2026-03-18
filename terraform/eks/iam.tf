# Tạo Policy cho phép đọc Secret cụ thể
resource "aws_iam_policy" "eks_secrets_policy" {
  name        = "EKSSecretsManagerPolicy"
  description = "Cho phep EKS doc secret tu Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:ap-southeast-1:837497587440:secret:prod/ecommerce/db-creds-*"
      }
    ]
  })
}

# Tạo IAM Role gắn với Service Account trong K8s
module "allow_secrets_manager_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version   = "~> 5.0"
  role_name = "eks-secrets-manager-role"

  role_policy_arns = {
    policy = aws_iam_policy.eks_secrets_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:ecommerce-sa"] # Namespace:ServiceAccount
    }
  }
}