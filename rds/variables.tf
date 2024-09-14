variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database"
  type    = string
  default     = "mydb"
}

variable "db_username" {
  description = "The master username for the database"
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  default     = "password123"
  sensitive   = true
}
