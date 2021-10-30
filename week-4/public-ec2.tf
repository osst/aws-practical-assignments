resource "aws_instance" "public-ec2-instance" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = var.ec2_key_name
  vpc_security_group_ids = [
    aws_security_group.ssh-sg.id,
    aws_security_group.web-sg.id,
    aws_security_group.outbound-sg.id
  ]
  subnet_id = aws_subnet.public-subnet.id
  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Public server" > /var/www/html/index.html
            EOF 
}

resource "aws_security_group" "ssh-sg" {
  name = "ssh-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-sg" {
  name = "web-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound-sg" {
  name = "outbound-sg"
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ec2_instance_public_ip" {
  value = aws_instance.public-ec2-instance.public_ip
}
