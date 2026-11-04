output "name" {
  value = aws_db_instance.db.db_name
}

output "port" {
  value = aws_db_instance.db.port
}

output "engine" {
  value = aws_db_instance.db.engine
}

output "username" {
  value = aws_db_instance.db.username
}

output "password" {
  value     = aws_db_instance.db.password
  sensitive = true
}

output "endpoint" {
  value = aws_db_instance.db.endpoint
}

output "address" {
  value = aws_db_instance.db.address
}
