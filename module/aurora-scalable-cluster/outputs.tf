output "db_address" {
  value       = aws_rds_cluster.mysql_db_cluster.endpoint
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = aws_rds_cluster.mysql_db_cluster.port
  description = "The port the database is listening on"
}

output "db_reader_endpoint" {
  value       = aws_rds_cluster.mysql_db_cluster.reader_endpoint
  description = "A read-only endpoint for the Aurora cluster; automatically load-balanced across replicas"
}

output "db_engine_version_actual" {
  value       = aws_rds_cluster.mysql_db_cluster.engine_version_actual
  description = "The running version of the database"
}

output "db_cluster_arn" {
  value       = aws_rds_cluster.mysql_db_cluster.engine_version_actual
  description = "Amazon Resource Name (ARN) of cluster"
}

output "db_kms_key_id" {
  value       = aws_rds_cluster.mysql_db_cluster.kms_key_id
  description = "The ARN for the KMS encryption key."
}

output "db_cluster_instance_class" {
  value       = aws_rds_cluster.mysql_db_cluster.db_cluster_instance_class
  description = "The compute and memory capacity of each DB instance."
}
