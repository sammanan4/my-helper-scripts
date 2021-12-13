# Install Collectd

```
sudo apt install collectd collectd-utils
```

enable the plugins, in `/etc/collectd/collectd.conf`

```
sudo systemctl enable collectd.service
```

# Installing Graphite

```
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get -y install graphite-web graphite-carbon
```
```
sudo apt-get install -y postgresql libpq-dev python3-psycopg2
```

```
vi setup.sql
```

```
CREATE USER graphite WITH PASSWORD 'password';
CREATE DATABASE graphite WITH OWNER graphite;
```

```
sudo -u postgres psql -f setup.sql
```

```
sudo vi /etc/graphite/local_settings.py
```

Update the following variables
```
SECRET_KEY = 'random_string'
TIME_ZONE = '' (optional)
USE_REMOTE_USER_AUTHENTICATION = True

DATABASES = {
	'default': {
		'NAME': 'graphite',
		'ENGINE': 'django.db.backends.postgresql_psycopg2',
		'USER': 'graphite',
		'PASSWORD': 'password',
		'HOST': '127.0.0.1',
		'PORT': ''
	}
}
```

replace some erronous code
```
sudo sed -i 's/from cgi import parse_qs/from urllib.parse import parse_qs/' /usr/lib/
python3/dist-packages/graphite/render/views.py
```

```
sudo sed -i -E "s/('django.contrib.contenttypes')/\1,\n  'django.contrib.messages'/" /usr/lib/python3/dist-packages/graphite/app_settings.py
```

```
sudo graphite-manage migrate --run-syncdb
```

Create superuser to access graphite web
```
sudo graphite-manage createsuperuser
```

```
sudo chmod -R 777 /var/log/graphite
```

```
sudo vi /etc/default/graphite-carbon
```
Update the following variable
```
CARBON_CACHE_ENABLED=true
```

```
sudo vi /etc/carbon/carbon.conf
```
Update the following variable
```
ENABLE_LOGROTATION = True
```

## Receive metrics from statsd server into graphite
```
sudo vi /etc/carbon/storage-schemas.conf
```
insert the following content
```
[statsd]
pattern = ^stats.*
retentions = 10s:1d,1m:7d,10m:1y
```

## Setup apache for Graphite

```
sudo apt-get install apache2 libapache2-mod-wsgi-py3 -y
```

```
sudo a2dissite 000-default
```

```
sudo cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available
```

```
sudo a2ensite apache2-graphite
```

```
sudo service apache2 reload
```

## Install StatsD Server

```
sudo apt-get install -y git devscripts debhelper dh-systemd
```

```
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
```

```
sudo apt-get install -y nodejs
```

```
mkdir ~/build
```

```
cd ~/build
```

```
git clone https://github.com/etsy/statsd.git
```

```
cd statsd
```

```
dpkg-buildpackage
```

```
cd ..
```

```
sudo dpkg -i statsd_0.9.0-1_all.deb
```

```
cd ~
```

## Install Grafana

```
sudo apt-get install -y apt-transport-https
```

```
sudo apt-get install -y software-properties-common wget
```

```
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
```

```
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
```

```
sudo apt-get update -y
```

```
sudo apt-get install grafana -y
```

```
sudo service grafana-server start
```

```
sudo service carbon-cache stop
```

```
sudo service carbon-cache start
```

```
sudo service statsd restart
```

```
sudo service apache2 reload
```


# Grafana defaults 
* port: 3000
* username: admin
* password: admin



# Receive metrics from Collectd into Graphite

```
sudo vi /etc/carbon/storage-schemas.conf
```
Insert the following contents
```
[collectd]
pattern = ^collectd.*
retentions = 20s:1d, 5m:7d, 10m:1y
```

```
sudo systemctl restart carbon-cache
```

```
sudo systemctl restart collectd
```
