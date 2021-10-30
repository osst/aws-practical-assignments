resource "aws_instance" "nat-instance" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = var.ec2_key_name
  vpc_security_group_ids = [
    aws_security_group.ssh-sg.id,
    aws_security_group.web-sg.id,
    aws_security_group.https-sg.id,
    aws_security_group.outbound-sg.id
  ]
  source_dest_check = false
  subnet_id = aws_subnet.public-subnet.id
  user_data = <<-EOF
              #!/bin/bash
              sysctl -w net.ipv4.ip_forward=1
              /sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
              service iptables save
            EOF
}

resource "aws_security_group" "https-sg" {
  name = "https-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
