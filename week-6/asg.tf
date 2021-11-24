resource "aws_autoscaling_group" "asg" {
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  target_group_arns = [aws_lb_target_group.target-group.arn]
  vpc_zone_identifier = [
    aws_subnet.public-subnet1.id,
    aws_subnet.public-subnet2.id
  ]

  launch_template {
    id      = aws_launch_template.public-ec2.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "public-ec2" {
  name = "public-ec2-template"
  image_id = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name = var.ec2_key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-profile.name
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type = "gp2"
      delete_on_termination = true
      volume_size = 8
    }
  }
  vpc_security_group_ids = [
    aws_security_group.ssh-sg.id,
    aws_security_group.web-sg.id,
    aws_security_group.outbound-sg.id
  ] 
  user_data = base64encode(<<-EOF
              #!/bin/bash -x
              sudo yum -y install java-1.8.0-openjdk-devel
              aws s3 cp s3://${var.s3_bucket_name}/calc-0.0.2-SNAPSHOT.jar /calc.jar
              java -jar /calc.jar
            EOF
  )
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
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role_policy" "fullaccess-policy" {
  name = "fullaccess-policy"
  role = aws_iam_role.ec2-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "rds:*",
        "dynamodb:*",
        "sns:*",
        "sqs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}