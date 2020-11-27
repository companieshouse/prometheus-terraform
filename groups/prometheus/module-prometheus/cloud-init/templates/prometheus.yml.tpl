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
            - region: ${region}
              port: ${prometheus_metrics_port}
          relabel_configs:
            - source_labels: [__meta_ec2_tag_Name]
              regex: ${tag_name_regex}-web
              action: keep
              # Use the instance ID as the instance label
            - source_labels: [__meta_ec2_instance_id]
              target_label: instance

        - job_name: node
          scrape_interval: 15s
          scrape_timeout: 15s
          metrics_path: /metrics
          scheme: http
          ec2_sd_configs:
            - region: ${region}
              port: 9100
          relabel_configs:
            - source_labels: [__meta_ec2_tag_Name]
              regex: ${tag_name_regex}-web|${tag_name_regex}-worker
              action: keep
            - source_labels: [__meta_ec2_instance_id]
              target_label: instance
            - source_labels: [__meta_ec2_tag_Name]
              target_label: tagname

        - job_name: github
          static_configs:
          - targets: ['localhost:9171']
          scrape_interval: 1m
          scrape_timeout: 1m
          metrics_path: /metrics
          scheme: http
