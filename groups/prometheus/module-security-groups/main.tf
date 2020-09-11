resource "aws_security_group" "prometheus_server" {
  name        = "${var.environment}-${var.tag_service}-server"
  description = "Security group for Prometheus ${var.environment} instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidrs
    description = "SSH access"
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.prometheus_cidrs
    description = "Prometheus API"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound traffic"
  }

  tags = {
    Name         = "${var.environment}-${var.tag_service}-security-group"
    Environment  = var.environment
    Service      = var.tag_service
    AnsibleGroup = "${var.tag_service}-${var.environment}"
  }
}

output "vpc_security_group_ids" {
  value = aws_security_group.prometheus_server.id
}
