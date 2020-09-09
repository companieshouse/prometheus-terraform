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
          static_configs:
          - targets:
            - ${prometheus_web_fqdn}:${prometheus_metrics_port}
