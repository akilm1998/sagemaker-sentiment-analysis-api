########################################
# infra/github-oidc/main.tf
########################################

########################################
# 1) OpenID Connect provider (GitHub Actions)
########################################
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Known GitHub token CA thumbprints (include both common ones)
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Name    = "${var.project}-github-oidc-provider"
    Project = var.project
  }
}

########################################
# 2) IAM Role with trust for web identity
########################################
data "aws_iam_policy_document" "github_oidc_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    # Audience must be sts.amazonaws.com
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Sub claim controls which repos/refs can assume the role.
    # We use StringLike so var.github_ref_pattern can contain wildcards.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [var.github_ref_pattern]
    }
  }
}

resource "aws_iam_role" "github_oidc_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume.json

  tags = {
    Name    = "github-oidc-role"
    Project = var.project
  }
}

########################################
# 3) Attach AdministratorAccess (change to least-privilege in production)
########################################
resource "aws_iam_role_policy_attachment" "attach_administrator" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

########################################
# Outputs
########################################
output "oidc_provider_arn" {
  description = "ARN of the created OIDC provider (token.actions.githubusercontent.com)"
  value       = aws_iam_openid_connect_provider.github_actions.arn
}

output "oidc_provider_url" {
  description = "OIDC provider URL"
  value       = aws_iam_openid_connect_provider.github_actions.url
}

output "github_oidc_role_arn" {
  description = "ARN of the IAM role that GitHub Actions can assume"
  value       = aws_iam_role.github_oidc_role.arn
}
