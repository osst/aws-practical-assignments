resource "aws_lb" "load-balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.web-sg.id,
    aws_security_group.outbound-sg.id
  ]
  subnets            = [
    aws_subnet.public-subnet.id,
    aws_subnet.private-subnet.id,
  ]
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_lb_target_group" "target-group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "tga1" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.public-ec2-instance.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tga2" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.private-ec2-instance.id
  port             = 80
}

output "load_balancer_dns" {
  value = aws_lb.load-balancer.dns_name
}