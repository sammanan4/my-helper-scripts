# Setup HAProxy
```
sudo apt update
```
```
sudo apt install --no-install-recommends software-properties-common
```
```
sudo add-apt-repository ppa:vbernat/haproxy-2.4 -y
```
```
sudo apt update
```
```
sudo apt install haproxy=2.4.\*
```
```
haproxy -v
```

## Setup HTTPS
Open haproxy configuration file
```
sudo vi /etc/haproxy/haproxy.cfg 
```

Paste the following contents into the cfg
```
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


frontend Local_Server
    bind *:80

    mode http
    
    
    # Test URI to see if its a letsencrypt request
    acl letsencrypt-acl path_beg /.well-known/acme-challenge/
    use_backend letsencrypt-backend if letsencrypt-acl

# LE Backend
backend letsencrypt-backend
    server letsencrypt 127.0.0.1:8888
```
Run the following command to get the certificate
```
sudo certbot certonly --standalone -d <your-domain> --non-interactive --agree-tos --email <email> --http-01-port=8888
```
We can as many domains as we like near like -d &lt;domain-1&gt; -d &lt;domain-2&gt;.  

HAProxy requires the certificate and the private key in a single file.  
A single folder will contain the key for all the subdomains.  
Create the same using the command below  
```
sudo cat /etc/letsencrypt/live/<your-domain>/fullchain.pem /etc/letsencrypt/live/<your-domain>/privkey.pem > /etc/haproxy/haproxy.pem
```

Now that we have HTTPS set up.
Let's update the haproxy.cfg with our domains.
Update your cfg with the following content


```
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http


frontend Local_Server
    bind *:80
    bind *:443 ssl crt /etc/haproxy/haproxy.pem
    mode http
    
    # Redirect if HTTPS is *not* used
    redirect scheme https code 301 if !{ ssl_fc }
    
    # Test URI to see if its a letsencrypt request
    acl letsencrypt-acl path_beg /.well-known/acme-challenge/
    use_backend letsencrypt-backend if letsencrypt-acl

    # check which domain was accessed
    acl devpro hdr(host) -i dev-pro.cloudtdms.com
    # we can add more domains in the same format
    # acl <identifier> hdr(host) -i <domain>
    
    # decide which backend to server depending on the domain accessed
    use_backend dev_pro_server if devpro

    # we can add more backends in the same format
    # use_backend <backend_identifier> if <acl_identifier>


backend dev_pro_server
    mode http
    option forwardfor
    http-request set-header Upgrade $http_upgrade
    http-request set-header Connection "upgrade" 
    server dev-pro.cloudtdms.com  localhost:8080

# we can add more backends for more nodes in the same format
# backend <backend_identifier>
#     mode http
#     option forwardfor
#     http-request set-header Upgrade $http_upgrade
#     http-request set-header Connection "upgrade" 
#     server <domain> <ip:port>

    
# LetsEncrypt Backend
backend letsencrypt-backend
    server letsencrypt 127.0.0.1:8888
```

To add more domains, run the certbot command again with additional domains and repeat the same steps as defined above.

## Certificate Renewal

Create a script
```
sudo vi /opt/update-certs.sh
```
Insert the following contents into the script
(Replace the domain folder with what you have in the system)
```
#!/usr/bin/bash

# Renew the certificate
certbot renew --force-renewal --http-01-port=8888

# Concatenate new cert files, with less output (avoiding the use tee and its output to stdout)
bash -c "cat /etc/letsencrypt/live/<domain>/fullchain.pem /etc/letsencrypt/live/<domain>/privkey.pem > /etc/haproxy/haproxy.pem"

# Reload  HAProxy
service haproxy reload

```
Add the execute permission to the script
```
sudo chmod u+x /opt/update-certs.sh
```

certbot creates a cron job for the renewal of the certificates
Comment the default cron job, and insert a new job with our script as command

```
sudo vi /etc/cron.d/certbot
```
Insert the following line, and comment the default one
```
0 0 1 * * root bash /opt/update-certs.sh
```
