# Install Elastic-Uptime

```
sudo apt update
```
```
sudo apt upgrade
```

## Install JVM
```
sudo apt install default-jre
```
```
sudo apt install openjdk-11-jdk
```
Check java version
```
java -version
```



## Install Elastic Search

Download the debian package
```
curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.9.3-amd64.deb
```
Install the package
```
sudo dpkg -i elasticsearch-7.9.3-amd64.deb
```
Start the elasticsearch server
```
sudo /etc/init.d/elasticsearch start
```
Make sure elastic search is running
```
curl http://127.0.0.1:9200
```
Response should be like this
```
{
  "name" : "QtI5dUu",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "DMXhqzzjTGqEtDlkaMOzlA",
  "version" : {
    "number" : "7.9.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "00d8bc1",
    "build_date" : "2018-06-06T16:48:02.249996Z",
    "build_snapshot" : false,
    "lucene_version" : "7.3.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

## Install Kibana
Download the package
```
curl -L -O https://artifacts.elastic.co/downloads/kibana/kibana-7.9.3-linux-x86_64.tar.gz
```
Extract the package
```
tar xzvf kibana-7.9.3-linux-x86_64.tar.gz
```
Start the server
```
cd kibana-7.9.3-linux-x86_64/
```
```
./bin/kibana
```
To launch the Kibana web interface, point your browser to port 5601. For example, http://127.0.0.1:5601.




## Install Metricbeat
Download the package
```
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.9.3-amd64.deb
```
Install the package
```
sudo dpkg -i metricbeat-7.9.3-amd64.deb
```


## Ship metrics to Elasticsearch
* Make sure Elasticsearch and Kibana are running
* Enable system module of Metricbeat
```
sudo metricbeat modules enable system 
```
* Setup initial environment
```
sudo metricbeat modules enable system
```
* Allow remote connections to kibana
```
vi kibana-7.9.3-linux-x86_64/config/kibana.yml
```
* Change the following line
```
server.host: "localhost"
```
to
```
server.host: "0.0.0.0"
```
* Start metricbeat (maybe update /etc/metricbeat/metricbeat.yml)
```
sudo service metricbeat start
```
