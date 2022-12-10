# usage: "value" = "module.<module-name>.<var-name>"
# i.e. "value = module.db-cluster-dev-dev.db_address"
# i.e. 2 "value = module.db-cluster-qa.db_address"

# local terra dir output

output "server_port" {
  value       = var.server_port
  description = "The port of the web server cluster"
}

# web cluster output

output "alb_dns_name" {
  value       = module.webserver-cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

# remote-state-s3 module outputs

output "s3_bucket_arn" {
  value       = module.remote-state-s3.s3_bucket_arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = module.remote-state-s3.dynamodb_table_name
  description = "The name of the DynamoDB table"
}

# db cluster module outputs

output "db_address" {
  value       = module.db-cluster-dev.db_address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = module.db-cluster-dev.db_port
  description = "The port the database is listening on"
}

output "db_reader_endpoint" {
  value       = module.db-cluster-dev.db_reader_endpoint
  description = "A read-only endpoint for the Aurora cluster; automatically load-balanced across replicas"
}

output "db_engine_version_actual" {
  value       = module.db-cluster-dev.db_engine_version_actual
  description = "The running version of the database"
}

output "db_cluster_arn" {
  value       = module.db-cluster-dev.db_cluster_arn
  description = "Amazon Resource Name (ARN) of cluster"
}

output "db_kms_key_id" {
  value       = module.db-cluster-dev.db_kms_key_id
  description = "The ARN for the KMS encryption key."
}

output "db_cluster_instance_class" {
  value       = module.db-cluster-dev.db_cluster_instance_class
  description = "The compute and memory capacity of each DB instance."
}
