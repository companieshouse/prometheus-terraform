# Route 53 DNS records for EC2 Instances
resource "aws_route53_record" "prometheus_server" {
  count    = var.instance_count
  zone_id  = var.zone_id
  name     = "${var.tag_service}-server${count.index+1}.${var.tag_environment}.${var.zone_name}"
  type     = "A"
  ttl      = "300"
  records  = [var.ec2_instance_private_ips[count.index]]
}