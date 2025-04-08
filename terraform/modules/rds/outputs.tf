output "db_endpoint" {
  description = "Endpoint de la base de données"
  value       = aws_db_instance.mariadb.endpoint
}

output "db_name" {
  value = aws_db_instance.mariadb.db_name
}
