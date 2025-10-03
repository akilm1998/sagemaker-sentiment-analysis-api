terraform {
  backend "s3" {
    bucket         = "akil-tf-bucket1281"
    key            = "github-oidc/sagemaker-sentiment/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "all-tf-locks"
    encrypt        = true
  }
}
