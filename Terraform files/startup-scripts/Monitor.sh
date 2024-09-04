#### Install Prpmetheus (Runs on 9090)

apt update

wget https://github.com/prometheus/prometheus/releases/download/v2.54.0/prometheus-2.54.0.linux-amd64.tar.gz

tar -xvf prometheus-2.54.0.linux-amd64.tar.gz

rm -rf  prometheus-2.54.0.linux-amd64.tar.gz

cd prometheus-2.54.0.linux-amd64/

./prometheus &

#Install Grafana (Runs on 3000)

cd

sudo apt-get install -y adduser libfontconfig1 musl

wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.1.3_amd64.deb

sudo dpkg -i grafana-enterprise_11.1.3_amd64.deb

sudo /bin/systemctl start grafana-server

sudo /bin/systemctl enable grafana-server

#### Install BlackBox Exporter (Runs on 9115)

wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.25.0/blackbox_exporter-0.25.0.linux-amd64.tar.gz

tar -xvf  blackbox_exporter-0.25.0.linux-amd64.tar.gz

rm -rf  blackbox_exporter-0.25.0.linux-amd64.tar.gz

cd blackbox_exporter-0.25.0.linux-amd64

./blackbox_exporter &


######## Define the path to the prometheus.yml configuration file  #########
PROMETHEUS_CONFIG_FILE="/prometheus-2.54.0.linux-amd64/prometheus.yml"

# Define the Blackbox Exporter configuration
BLACKBOX_CONFIG="
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['34.45.79.106:9100']

  - job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['34.45.79.106:8080']

  - job_name: 'blackbox'
    metrics_path: /probe
    params:
      module: [http_2xx]  # Look for a HTTP 200 response.
    static_configs:
      - targets:
        - http://prometheus.io    # Target to probe with http.
        - 
        - http://example.com:8080 # Target to probe with http on port 8080.
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 127.0.0.1:9115  # The blackbox exporter's real hostname:port.
"

# Check if the configuration file exists
if [ -f "$PROMETHEUS_CONFIG_FILE" ]; then
  # Append the Blackbox Exporter configuration to prometheus.yml
  echo "$BLACKBOX_CONFIG" >> "$PROMETHEUS_CONFIG_FILE"
else
  echo "Prometheus configuration file not found at $PROMETHEUS_CONFIG_FILE"
fi


####  pgrep prometheus

####  kill ----

####  ./prometheus &