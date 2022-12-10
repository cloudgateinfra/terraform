# these two vars below specify the names of the remote tf.state file
# this prevents locking and keeps data secure

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}
