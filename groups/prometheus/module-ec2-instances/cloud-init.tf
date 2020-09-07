variable "user_data_merge_strategy" {
  default     = "list(append)+dict(recurse_array)+str()"
  description = "Merge strategy to apply to user-data sections for cloud-init"
}

data "template_cloudinit_config" "config" {
  count         = var.instance_count
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "#cloud-config"
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/templates/prometheus.yml.tpl", {
      web_fqdn=""
      metrics_port=""
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/files/bootstrap-commands.yml", {
      hostname="${var.tag_environment}-${var.tag_service}-instance${count.index+1}"
    })
  }

}
