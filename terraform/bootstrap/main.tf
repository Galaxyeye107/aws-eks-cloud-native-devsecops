provider "aws" {
  region = "ap-southeast-1" # Chọn region gần bạn (Singapore)
}

# 1. S3 Bucket để lưu Terraform State (Bật mã hóa và versioning)
resource "aws_s3_bucket" "terraform_state" {
  bucket = "trung-devsecops-eks-tfstate-prod"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = "trung-devsecops-eks-tfstate-prod"
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = "trung-devsecops-eks-tfstate-prod"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 2. DynamoDB Table để khóa State (Tránh conflict khi 2 người cùng chạy pipeline)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "devsecops-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# 3. Cấu hình OIDC cho GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # Thumbprint chuẩn của GitHub
}

# 4. Tạo IAM Role cho CI/CD Pipeline với nguyên tắc Least Privilege trên OIDC
resource "aws_iam_role" "github_actions" {
  name = "github-actions-devsecops-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          "StringLike" = {
            # BẢO MẬT CỐT LÕI: Chỉ repository NÀY mới được phép xin Token
            "token.actions.githubusercontent.com:sub" : "repo:Galaxyeye107/aws-eks-cloud-native-devsecops:*"
          },
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Tạm thời cấp quyền Admin cho Role này để nó có thể dựng EKS/VPC ở các bước sau.
# Ở môi trường Prod thực tế, chúng ta sẽ viết policy chặt chẽ hơn.
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}