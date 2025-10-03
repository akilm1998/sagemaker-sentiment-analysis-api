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

variable "role_name" {
  description = "Name of the IAM role to create"
  type        = string
  default     = "circleci-oidc-role"
}

variable "circleci_org_id" {
  description = "CircleCI Organization ID"
  type        = string
  default     = "96cd6b0b-b5a1-4660-aee5-2602662d5e9f"
}

variable "circleci_project_id" {
  description = "CircleCI project ID (use '*' to allow all projects in the org)"
  type        = string
  default     = "*"
}

variable "AWS_ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
  default     = "313078327096"
}

variable "circleci_thumbprint" {
  description = "Thumbprint for the CircleCI OIDC provider"
  type        = string
  default     = "20f540dd952c6054be3fc82f7a222a051df2b09b"
}
