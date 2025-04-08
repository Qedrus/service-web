resource "aws_db_instance" "mariadb" {
  identifier             = "mariadb-instance"
  engine                 = "mariadb"
  engine_version         = "10.6"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mariadb10.6"
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = var.db_subnet_group_name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
