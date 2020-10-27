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
    content_type              = "text/cloud-config"
    content                   = templatefile("${path.module}/cloud-init/templates/prometheus.yml.tpl", {
      prometheus_metrics_port = var.prometheus_metrics_port
      prometheus_tag_regex    = var.prometheus_tag_regex
    })
    merge_type = var.user_data_merge_strategy
  }

  part {
    content_type  = "text/cloud-config"
    content       = templatefile("${path.module}/cloud-init/files/bootstrap-commands.yml", {
      hostname    ="${var.environment}-${var.service}-instance${count.index+1}"
    })
  }

}
