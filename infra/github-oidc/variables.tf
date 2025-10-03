variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name prefix for resource naming"
  type        = string
  default     = "sagemaker-sentiment"
}

variable "github_owner" {
  description = "GitHub owner/org for the repo"
  type        = string
  default     = "akilm1998"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "sagemaker-sentiment-analysis-api"
}

variable "github_ref_pattern" {
  description = "Sub claim pattern for allowed branches/refs (StringLike) e.g. repo:ORG/REPO:ref:refs/heads/main or repo:ORG/REPO:*"
  type        = string
  # This pattern allows ANY repo and ANY branch
  default = "repo:*/*:ref:refs/heads/*"
}

variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "github-actions-oidc-role"
}
