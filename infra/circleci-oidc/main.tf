########################################
# 1) OpenID Connect provider
########################################
resource "aws_iam_openid_connect_provider" "circleci_oidc" {
  url             = "https://oidc.circleci.com/org/${var.circleci_org_id}"
  client_id_list  = [var.circleci_org_id]
  thumbprint_list = [var.circleci_thumbprint]

  tags = {
    Name    = "circleci-oidc-provider"
    Project = var.project
  }
}

########################################
# 2) IAM Role with trust for web identity
#    Using the exact trust JSON you provided (interpolated with variables)
########################################
resource "aws_iam_role" "circleci_oidc_role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.AWS_ACCOUNT_ID}:oidc-provider/oidc.circleci.com/org/${var.circleci_org_id}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "oidc.circleci.com/org/${var.circleci_org_id}:sub": "org/${var.circleci_org_id}/project/${var.circleci_project_id}/user/*"
        }
      }
    }
  ]
}
EOF

  tags = {
    Name    = var.role_name
    Project = var.project
  }
}

########################################
# 3) Attach AdministratorAccess (change to least-privilege in production)
########################################
resource "aws_iam_role_policy_attachment" "attach_administrator" {
  role       = aws_iam_role.circleci_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

########################################
# Outputs
########################################
output "oidc_provider_arn" {
  description = "ARN of the created OIDC provider (https://oidc.circleci.com)"
  value       = aws_iam_openid_connect_provider.circleci_oidc.arn
}

output "oidc_provider_url" {
  description = "OIDC provider URL"
  value       = aws_iam_openid_connect_provider.circleci_oidc.url
}

output "circleci_oidc_role_arn" {
  description = "ARN of the IAM role that CircleCI can assume"
  value       = aws_iam_role.circleci_oidc_role.arn
}
