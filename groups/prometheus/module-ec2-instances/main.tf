data "aws_ami" "prometheus" {
  owners      = ["self"]
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
  instance_type          = var.instance_type
  subnet_id              = element(var.application_subnets,count.index)
  key_name               = var.ssh_keyname
  vpc_security_group_ids = [var.vpc_security_group_ids]
  user_data_base64       = data.template_cloudinit_config.config.*.rendered[count.index]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    Name         = "${var.environment}-${var.tag_service}-instance${count.index+1}"
    Environment  = var.environment
    Service      = var.tag_service
    HostName     = "${var.tag_service}.${var.environment}.${var.zone_name}"
    Domain       = var.zone_name
    AnsibleGroup = "${var.tag_service}-${var.environment}"
  }

}

output "ec2_instance_private_ip" {
  value = aws_instance.prometheus_instance[*].private_ip
}
