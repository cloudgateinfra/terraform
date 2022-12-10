# root module - remote state s3

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# below resources setup s3 bucket & dynamoDB table for remote backend state use
# this is to be configured when calling this root module into a web-app dir
resource "aws_s3_bucket" "terraform_state_dev" {
  bucket        = var.bucket_name
  force_destroy = true

  # prevent accidental deletion
  // lifecycle {
  //  prevent_destroy = true // enable for prod/stage 
  // }

  // destroy the bucket as part of automated tests
  // do not use for prod/stage
  // force_destroy = true
}

# enable versioning to see full revision history of your state files
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state_dev.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state_dev.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state_dev.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  # prevent accidental deletion
  // lifecycle {
  //  prevent_destroy = true // enable for prod/stage
  // }

  attribute {
    name = "LockID"
    type = "S"
  }
}
