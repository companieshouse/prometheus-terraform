# Load Balancer
resource "aws_lb" "prometheus_server" {
  name               = "${var.environment}-${var.service}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.prometheus_server.id]
  subnets            = var.application_subnets[*]
  tags = {
    Environment     = var.environment
    Service         = var.service
  }
}

# Target configuration for HTTP / port 9090
resource "aws_lb_target_group" "prometheus_server_web" {
  name        = "${var.environment}-${var.service}-web"
  port        = 9090
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = "5"
    path                = "/graph"
    protocol            = "HTTP"
    interval            = 30
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "prometheus_server_web" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.prometheus_server_web.arn
  target_id        = aws_instance.prometheus_instance[count.index].private_ip
  port             = 9090
}
resource "aws_lb_listener" "prometheus_server_listener_80" {
  load_balancer_arn = aws_lb.prometheus_server.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl_certificate_id
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_server_web.arn
  }
}
