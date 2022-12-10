# dev webapp infra

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# designate provider in non-root modules like here only:
provider "aws" {
  region = "us-west-2"

  // shared_config_files      = ["/Users/user1/.aws/config"]
  // shared_credentials_files = ["/Users/user1/.aws/credentials"]
  // profile                  = "default"//"dev"
}

# configures terraform to use remote backend for state file
# see readme for details; this is configured via `terraform init`
// terraform {
//   backend "s3" {
//     bucket         = "tf-state-dev" // make same as default bucket var in variables.tf
//     key            = "default-workspace/terraform.tfstate"
//     region         = "us-west-2"
//     dynamodb_table = "tf-lock-dev" // make same as default table var in variables.tf
//     encrypt        = true
//   }
// }

# module creates s3 bucket and dynamoDB table for remote backend state configs
module "remote-state-s3" {
  source = "/Users/user1/Local/infrastructure/modules/remote-state-s3"
  bucket_name         = var.bucket_name
  table_name          = var.table_name
}

# module creates aurora mysql db cluster via rds/aws for app terra dir you are configuring here
module "db-cluster-dev" {
  source = "/Users/user1/Local/infrastructure/modules/db-cluster-dev"
}

module "webserver-cluster" {
  source = "/Users/user1/Local/infrastructure/modules/webserver-cluster"
  cluster_name  = var.cluster_name
  // db_remote_state_bucket = var.db_remote_state_bucket
  // db_remote_state_key    = var.db_remote_state_key
  instance_type = "t3.large"
  min_size      = 2
  max_size      = 4
}

# increase aws asg to max ec2 instances during peak business hours
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 4
  recurrence             = "0 9 * * *"
  autoscaling_group_name = module.webserver-cluster.asg_name
}

# decrease aws asg to min ec2 instances during off business hours
resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 4
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = module.webserver-cluster.asg_name
}
