# root module - db

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

# currently all modules are saved on same backend state file in s3
# optinally can set own remote state just for database

//   backend "s3" {
//     bucket         = "bucket-dev"
//     key            = "default-workspace-db/terraform.tfstate"
//     region         = "us-west-2"
//     dynamodb_table = "table-dev"
//     encrypt        = true
//   }

}

# creates aurora cluster which manages cluster instances
resource "aws_rds_cluster" "mysql_db_cluster" { // change this to just db_cluster for consistency
  cluster_identifier      = "aurora-cluster-dev"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true // set false for prod/stage
  deletion_protection     = false // set true for prod/stage optionally
  port                    = 3406
  backup_retention_period = 5
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password

  # applies to engine mode "provisioned" set by default
  # this function not to be confused with "serverless"
  # this autoscales the db size depending on load
  serverlessv2_scaling_configuration {
    max_capacity = 128 // 1 ACU unit = 2 gigabtyes
    min_capacity = 50
  }

  # static storage in gigs
  // allocated_storage       = 100 // if not using autoscaled feature below

  # if you need to specify azs
  // availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

# creates as many instances as you like within specified aurora cluster
# auora cluster you set the instances here and aurora takes care of replicas automatically
resource "aws_rds_cluster_instance" "db_instance" {
  count              = 2
  instance_class     = "db.r4.large"
  identifier         = "dev-db-cluster-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.mysql_db_cluster.id
  engine             = aws_rds_cluster.mysql_db_cluster.engine
  engine_version     = aws_rds_cluster.mysql_db_cluster.engine_version
}
