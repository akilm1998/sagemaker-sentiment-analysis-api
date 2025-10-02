#########################################
# S3 bucket for Terraform state
#########################################
resource "aws_s3_bucket" "state_demo" {
  bucket = "akil-tf-bucket1281"

  tags = {
    Name    = "tf-bucket"
    Project = var.project
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.state_demo.id

  versioning_configuration {
    status = "Enabled"
  }
}

#########################################
# DynamoDB table for Terraform state locks
#########################################
resource "aws_dynamodb_table" "tf_locks" {
  name         = "all-tf-locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "all-tf-locks"
    Project = var.project
  }
}
