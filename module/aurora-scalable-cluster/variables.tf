variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = "dev_db_admin"
}

# config aws secrets to set pw instead for now testing
variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = "t4MvZBhFytkxAhDGntsh"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "dev_db_cluster"
}


# configurable rds instance vars
// variable "db_identifier_prefix" {
//   description = "Forces new resource. Creates a unique identifier beginning with the specified prefix."
//   type        = string
// }
//
// variable "db_deletion_protection" { // optional
//   description = "If true the database can't be deleted when this value is set to true. The default is false."
//   type        = boolean
// }
//
// variable "db_engine" {
//   description = "The type of DB service to use."
//   type        = string
// }
//
// variable "db_engine_version" {
//   description = "The mysql version to use."
//   type        = string
// }
//
// variable "mysql_port" {
//   description = "The DB port."
//   type        = string
// }
//
// variable "db_allocated_storage" {
//   description = "The amount of gigabytes for the DB to allocate."
//   type        = number
// }
//
// variable "db_instance_class" {
//   description = "The type of hardware the DB VM uses on AWS."
//   type        = string
// }
//
