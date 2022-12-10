variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080 // comment out "default = 8080" etc. to manually enter port on plan apply
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (i.e. m4.large)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

# if using a remote backend for tf.state files
// variable "db_remote_state_bucket" {
//   description = "The name of the S3 bucket for the database's remote state"
//   type        = string
// }
//
// variable "db_remote_state_key" {
//   description = "The path for the database's remote state in S3"
//   type        = string
// }

// variable "colon" {
//   description = "literal string colon i.e. ':'"
//   type        = string
//   default     = ":"
// }
