data "aws_ami" "prometheus" {
  owners      = [var.ami_owner]
  name_regex  = "^prometheus-ami-\\d.\\d.\\d"
  most_recent = true
  filter {
    name   = "name"
    values = ["prometheus-ami-${var.ami_version_pattern}"]
  }
}

resource "aws_instance" "prometheus_instance" {
  count                  = var.instance_count
  ami                    = data.aws_ami.prometheus.id
  iam_instance_profile   = aws_iam_role.ec2_readonly.name
  instance_type          = var.instance_type
  subnet_id              = element(var.application_subnets,count.index)
  key_name               = var.ssh_keyname
  vpc_security_group_ids = [aws_security_group.prometheus_server.id]
  user_data_base64       = data.template_cloudinit_config.config.*.rendered[count.index]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  volume_tags = {
    Snapshot = "daily"
    Name     = "${var.environment}-${var.service}-instance${count.index+1}"
  }

  tags = {
    Name         = "${var.environment}-${var.service}-instance${count.index+1}"
    Environment  = var.environment
    Service      = var.service
    HostName     = "${var.service}.${var.environment}.${var.dns_zone_name}"
    Domain       = var.dns_zone_name
    AnsibleGroup = "${var.service}-${var.environment}"
  }

}
