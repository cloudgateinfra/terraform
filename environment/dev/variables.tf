variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "web-cluster-dev"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080 // comment out "default = 8080" etc. to manually enter port on plan apply
}

# 2 input vars below define resource names of s3 bucket & dynamoDB table for remote state config
variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "tf-state-dev"
}

variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "tf-lock-dev"
}

# remote db backend state configs wip

// variable "db_remote_state_bucket" {
//   description = "The name of the S3 bucket used for the database's remote state storage"
//   type        = string
// }
//
// variable "db_remote_state_key" {
//   description = "The name of the key in the S3 bucket used for the database's remote state storage"
//   type        = string
// }

# mysql db config vars
# change "defaults" to config resource root module "mysql-db"

// variable "db_username" {
//   description = "The username for the database"
//   type        = string
//   sensitive   = true
// }
//
// variable "db_password" {
//   description = "The password for the database"
//   type        = string
//   sensitive   = true
// }
//
// variable "db_name" {
//   description = "The name to use for the database"
//   type        = string
//   default     = "dev_db"
// }
