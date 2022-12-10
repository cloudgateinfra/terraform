# these two outputs below output arn values
# of remote state file bucket and table from aws s3/dynamoDB

output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state_dev.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}
