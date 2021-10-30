resource "aws_instance" "private-ec2-instance" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = var.ec2_key_name
  vpc_security_group_ids = [
    aws_security_group.private-ssh-sg.id,
    aws_security_group.private-web-sg.id,
    aws_security_group.private-icmp-sg.id,
    aws_security_group.outbound-sg.id
  ]
  subnet_id = aws_subnet.private-subnet.id
  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Private server" > /var/www/html/index.html
            EOF 
}

resource "aws_security_group" "private-ssh-sg" {
  name = "private-ssh-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
}

resource "aws_security_group" "private-web-sg" {
  name = "private-web-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
}

resource "aws_security_group" "private-icmp-sg" {
  name = "private-icmp-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24"]
  }
}

output "ec2_private_instance_private_ip" {
  value = aws_instance.private-ec2-instance.private_ip
}
