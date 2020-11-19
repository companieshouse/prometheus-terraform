resource "aws_route53_record" "prometheus_server" {
  count    = var.instance_count
  zone_id  = var.dns_zone_id
  name     = "${var.service}-server${count.index+1}.${var.environment}.${var.dns_zone_name}"
  type     = "A"
  ttl      = "300"
  records  = aws_instance.prometheus_instance[*].private_ip
}

resource "aws_route53_record" "prometheus_service" {
  zone_id  = var.dns_zone_id
  name     = "${var.service}.${var.environment}.${var.dns_zone_name}"
  type    = "A"
  alias {
    name                   = aws_lb.prometheus_server.dns_name
    zone_id                = aws_lb.prometheus_server.zone_id
    evaluate_target_health = false
  }
}
