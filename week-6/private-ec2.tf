resource "aws_instance" "private-ec2-instance" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = var.ec2_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids = [
    aws_security_group.private-ssh-sg.id,
    aws_security_group.private-web-sg.id,
    aws_security_group.private-icmp-sg.id,
    aws_security_group.outbound-sg.id
  ]
  subnet_id = aws_subnet.private-subnet1.id
  user_data = <<-EOF
              #!/bin/bash -x
              sudo yum -y install java-1.8.0-openjdk-devel
              aws s3 cp s3://${var.s3_bucket_name}/persist3-0.0.1-SNAPSHOT.jar /persist.jar
              echo "${aws_db_instance.rds-instance.address}" > /hostvalue
              RDS_HOST=${aws_db_instance.rds-instance.address} java -jar /persist.jar
            EOF 
}

resource "aws_security_group" "private-ssh-sg" {
  name = "private-ssh-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}

resource "aws_security_group" "private-web-sg" {
  name = "private-web-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}

resource "aws_security_group" "private-icmp-sg" {
  name = "private-icmp-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}

output "ec2_private_instance_private_ip" {
  value = aws_instance.private-ec2-instance.private_ip
}