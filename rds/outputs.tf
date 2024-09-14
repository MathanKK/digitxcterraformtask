output "rds_endpoint" {
  description = "The endpoint of the MySQL RDS instance"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.mysql.id
}
