resource "aws_db_instance" "rds-instance" {
  allocated_storage    = 20
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  name                 = var.rds_name
  username             = var.rds_username
  password             = var.rds_password
  backup_retention_period = 0
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.rds-security-group.id
  ]
}

resource "aws_security_group" "rds-security-group" {
  name = "rds-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "rds_public_ip" {
  value = aws_db_instance.rds-instance.address
}

output "rds_port" {
  value = aws_db_instance.rds-instance.port
}
