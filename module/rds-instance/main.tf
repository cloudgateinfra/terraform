# single rds instance
 resource "aws_db_instance" "mysql_db" {
   deletion_protection = false
   skip_final_snapshot = true
   allocated_storage   = 100

   instance_class      = "db.t4g.2xlarge"
   identifier_prefix   = "dev-mysql-db"
   engine              = "mysql"
   engine_version      = "5.6.27"
   port                = "3406"

   username            = var.db_username
   password            = var.db_password
   db_name             = var.db_name
