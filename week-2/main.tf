terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ec2-instance" {
  ami             = "ami-0c2d06d50ce30b442"
  instance_type   = "t2.micro"
  key_name        = "os-keypair"
  security_groups = [
    aws_security_group.ssh-sg.name,
    aws_security_group.web-sg.name,
    aws_security_group.outbound-sg.name
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  user_data = <<-EOF
                #!/bin/bash
                aws s3 cp s3://ostasenko-training-bucket/os-textfile.txt /os-textfile.txt
              EOF 
}

resource "aws_security_group" "ssh-sg" {
  name = "ssh-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-sg" {
  name = "web-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "outbound-sg" {
  name = "outbound-sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2-role" {
  name = "ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = "${aws_iam_role.ec2-role.name}"
}

resource "aws_iam_role_policy" "s3-fullaccess-policy" {
  name = "s3-fullaccess-policy"
  role = "${aws_iam_role.ec2-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
