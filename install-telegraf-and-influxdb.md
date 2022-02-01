# Telegraf setup

### install deb package
```
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.20.4-1_amd64.deb
```
```
sudo dpkg -i telegraf_1.20.4-1_amd64.deb
```

### install influx

```
wget -qO- https://repos.influxdata.com/influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null
```
```
export DISTRIB_ID=$(lsb_release -si); export DISTRIB_CODENAME=$(lsb_release -sc)
```
```
echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list > /dev/null
```
```
sudo apt-get update && sudo apt-get install influxdb2
```

* go to port 8086 via browser and create user
* go to sources and create telegraf source
* copy the provided config
* save the config at telegraf machine /etc/telegraf/telegraf.conf
* set the token env var provided in /etc/default/telegraf (without export like => INFLUX_TOKEN=...)




# Add StatsD plugin

```
[[inputs.statsd]]
  ## Protocol, must be "tcp", "udp4", "udp6" or "udp" (default=udp)
  protocol = "udp4"

  ## MaxTCPConnection - applicable when protocol is set to tcp (default=250)
  max_tcp_connections = 250

  ## Enable TCP keep alive probes (default=false)
  tcp_keep_alive = false

  ## Specifies the keep-alive period for an active network connection.
  ## Only applies to TCP sockets and will be ignored if tcp_keep_alive is false.
  ## Defaults to the OS configuration.
  # tcp_keep_alive_period = "2h"

  ## Address and port to host UDP listener on
  service_address = ":8125"

  ## The following configuration options control when telegraf clears it's cache
  ## of previous values. If set to false, then telegraf will only clear it's
  ## cache when the daemon is restarted.
  ## Reset gauges every interval (default=true)
  delete_gauges = true
  ## Reset counters every interval (default=true)
  delete_counters = true
  ## Reset sets every interval (default=true)
  delete_sets = true
  ## Reset timings & histograms every interval (default=true)
  delete_timings = true

  ## Percentiles to calculate for timing & histogram stats.
  percentiles = [50.0, 90.0, 99.0, 99.9, 99.95, 100.0]

  ## separator to use between elements of a statsd metric
  metric_separator = "_"

  ## Parses tags in the datadog statsd format
  ## http://docs.datadoghq.com/guides/dogstatsd/
  ## deprecated in 1.10; use datadog_extensions option instead
  parse_data_dog_tags = false

  ## Parses extensions to statsd in the datadog statsd format
  ## currently supports metrics and datadog tags.
  ## http://docs.datadoghq.com/guides/dogstatsd/
  datadog_extensions = false

  ## Parses distributions metric as specified in the datadog statsd format
  ## https://docs.datadoghq.com/developers/metrics/types/?tab=distribution#definition
  datadog_distributions = false

  ## Statsd data translation templates, more info can be read here:
  ## https://github.com/influxdata/telegraf/blob/master/docs/TEMPLATE_PATTERN.md
  # templates = [
  #     "cpu.* measurement*"
  # ]
  templates = [
    "*.dag.*.*.duration measurement.measurement.dag_id.task_id.measurement",
    "*.dagrun.dependency-check.* measurement.measurement.measurement.dag_id",
    "*.dag_processing.last_duration.* measurement.measurement.measurement.dag_id",
    "*.dagrun.duration.*.* measurement.measurement.measurement.status.dag_id",
    "*.dagrun.schedule_delay.* measurement.measurement.measurement.dag_id",
    "*.dag_processing.last_runtime.* measurement.measurement.measurement.dag_id",
    "*.dag.loading-duration.* measurement.measurement.measurement.dag_id",
    "*.operator.*.* measurement.measurement.status.operator"
  ]

  ## Number of UDP messages allowed to queue up, once filled,
  ## the statsd server will start dropping packets
  allowed_pending_messages = 10000

  ## Number of timing/histogram values to track per-measurement in the
  ## calculation of percentiles. Raising this limit increases the accuracy
  ## of percentiles but also increases the memory usage and cpu time.
  percentile_limit = 1000

  ## Maximum socket buffer size in bytes, once the buffer fills up, metrics
  ## will start dropping.  Defaults to the OS default.
  # read_buffer_size = 65535

  ## Max duration (TTL) for each metric to stay cached/reported without being updated.
  # max_ttl = "10h"
```

### install Chronograf
```
wget https://dl.influxdata.com/chronograf/releases/chronograf_1.9.1_amd64.deb
```
```
sudo dpkg -i chronograf_1.9.1_amd64.deb
```
```
sudo service chronograf start
```
check port 8888

Dont forget to create an admin token on the influx DB using which you can authenticate
