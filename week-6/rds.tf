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
  db_subnet_group_name = aws_db_subnet_group.default.name
  publicly_accessible = false

  vpc_security_group_ids = [
    aws_security_group.rds-security-group.id
  ]
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [
    aws_subnet.private-subnet1.id,
    aws_subnet.private-subnet2.id
  ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds-security-group" {
  name = "rds-sg"
  vpc_id = aws_vpc.main.id
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
