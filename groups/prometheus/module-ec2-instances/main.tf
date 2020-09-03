# EC2 Instance
resource "aws_instance" "prometheus_instance" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = element(var.application_subnets,count.index)
  key_name               = var.ssh_keyname
  vpc_security_group_ids = [var.vpc_security_group_ids]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  tags = {
    Name         = "${var.tag_environment}-${var.tag_service}-instance${count.index+1}"
    Environment  = var.tag_environment
    Service      = var.tag_service
    HostName     = "${var.tag_service}.${var.tag_environment}.${var.zone_name}"
    Domain       = var.zone_name
    AnsibleGroup = "${var.tag_service}-${var.tag_environment}"
  }

  # Set hostname
  provisioner "remote-exec" {
    connection {
      host        = self.private_ip
      private_key = "${file("${var.private_key_path}")}"
    }
    inline = [
      "sudo hostnamectl set-hostname ${var.tag_environment}-${var.tag_service}-instance${count.index+1}",
    ]
  }
}

# Outputs
output "ec2_instance_private_ip" {
  value = aws_instance.prometheus_instance[*].private_ip
}
