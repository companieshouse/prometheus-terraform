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

# Configuration for Certificate

resource "aws_acm_certificate" "certificate" {
  domain_name               = "${var.service}.${var.environment}.${var.dns_zone_name}"
  subject_alternative_names = ["*.${var.service}.${var.environment}.${var.dns_zone_name}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      record  = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.dns_zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate_validation : record.fqdn]
}

# Listener configuration

resource "aws_lb_listener" "prometheus_server_listener_443" {
  load_balancer_arn  = aws_lb.prometheus_server.arn
  port               = "443"
  protocol           = "HTTPS"
  certificate_arn    = aws_acm_certificate_validation.certificate.certificate_arn
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_server_web.arn
  }
}

# Create a listener resource to redirect HTTP to HTTPS

resource "aws_lb_listener" "prometheus_server_listener_80_redirect" {
  load_balancer_arn = aws_lb.prometheus_server.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
