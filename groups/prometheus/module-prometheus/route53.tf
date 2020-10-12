resource "aws_route53_record" "prometheus_server" {
  count    = var.instance_count
  zone_id  = var.zone_id
  name     = "${var.service}-server${count.index+1}.${var.environment}.${var.zone_name}"
  type     = "A"
  ttl      = "300"
  records  = [aws_instance.prometheus_instance[count.index].private_ip]
}
