resource "aws_lb" "main_elb" {
  name = "aws-load-balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = var.security_group
  subnets = var.public_subnets
}

resource "aws_lb_target_group" "elb-tgp" {
  name = "web-tgp"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc
  target_type = "instance"

  health_check {
    path = "/"
    interval = 300
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200-300"
  }
}

resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = aws_lb.main_elb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.elb-tgp.arn
  }
}