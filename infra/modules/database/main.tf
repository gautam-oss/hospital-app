resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-db-subnet-${var.env}"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "main" {
  identifier              = "${var.project}-db-${var.env}"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_storage
  storage_encrypted       = true
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = var.env != "prod"
  deletion_protection     = var.env == "prod"
  backup_retention_period = var.env == "prod" ? 7 : 0
  multi_az                = var.env == "prod"
}
