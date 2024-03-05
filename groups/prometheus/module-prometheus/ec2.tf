data "aws_ami" "prometheus" {
  owners      = [var.ami_owner]
  name_regex  = "^prometheus-\\d.\\d.\\d"
  most_recent = true
  filter {
    name   = "name"
    values = ["prometheus-${var.ami_version_pattern}"]
  }
}

resource "aws_instance" "prometheus_instance" {
  count                  = var.instance_count
  ami                    = data.aws_ami.prometheus.id
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  instance_type          = var.instance_type
  subnet_id              = element(var.application_subnets,count.index)
  key_name               = var.ssh_keyname
  vpc_security_group_ids = [aws_security_group.prometheus_server.id]
  user_data_base64       = data.template_cloudinit_config.config.*.rendered[count.index]

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size_gb
    encrypted   = true
    kms_key_id  = module.ebs_kms.key_arn
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp3"
    volume_size = var.data_volume_size_gb
    encrypted   = true
    kms_key_id  = module.ebs_kms.key_arn
    snapshot_id = tolist(data.aws_ami.prometheus.block_device_mappings)[1].ebs.snapshot_id
  }

  ebs_block_device {
    device_name = "/dev/xvdc"
    volume_type = "gp3"
    volume_size = var.data_volume_size_gb
    encrypted   = true
    kms_key_id  = module.ebs_kms.key_arn
    snapshot_id = tolist(data.aws_ami.prometheus.block_device_mappings)[2].ebs.snapshot_id
  }

  volume_tags = {
    Snapshot = "daily"
    Name     = "${var.environment}-${var.service}-instance${count.index+1}"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    instance_metadata_tags      = "enabled"
    http_put_response_hop_limit = 2
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
