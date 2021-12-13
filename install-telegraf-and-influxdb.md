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
wget -qO- https://repos.influxdata.com/influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.
gpg.d/influxdb.gpg > /dev/null
```
```
export DISTRIB_ID=$(lsb_release -si); export DISTRIB_CODENAME=$(lsb_release -sc)
```
```
echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/${DISTRIB
_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list > /dev/null
```
```
sudo apt-get update && sudo apt-get install influxdb2
```

* go to port 8086 via browser and create user
* go to sources and create telegraf source
* copy the provided config
* save the config at telegraf machine /etc/telegraf/telegraf.conf
* set the token env var provided in /etc/default/telegraf
