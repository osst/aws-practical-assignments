resource "aws_lb" "load-balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [
    aws_security_group.web-sg.id,
    aws_security_group.outbound-sg.id
  ]
  subnets            = [
    aws_subnet.public-subnet1.id,
    aws_subnet.public-subnet2.id,
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

  health_check {
    path = "/actuator/health"
  }
}

output "load_balancer_dns" {
  value = aws_lb.load-balancer.dns_name
}