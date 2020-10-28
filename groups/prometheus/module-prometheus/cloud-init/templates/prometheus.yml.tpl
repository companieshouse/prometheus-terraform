write_files:
  - path: /etc/prometheus/prometheus.yml
    owner: prometheus:prometheus
    permissions: 0644
    content: |
      global:
        scrape_interval:     30s
        evaluation_interval: 30s

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
          - targets: ['localhost:9090']

        - job_name: concourse
          scrape_interval: 15s
          scrape_timeout: 15s
          metrics_path: /metrics
          scheme: http
          ec2_sd_configs:
            - region: eu-west-2
              port: ${prometheus_metrics_port}
          relabel_configs:
              # Only monitor Concourse instances
            - source_labels: [__meta_ec2_tag_Name]
              regex: ${tag_name_regex}
              action: keep
              # Use the instance ID as the instance label
            - source_labels: [__meta_ec2_instance_id]
              target_label: instance
