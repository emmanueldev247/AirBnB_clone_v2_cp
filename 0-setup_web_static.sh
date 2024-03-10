#!/usr/bin/env bash
# Bash script that sets up your web servers for the deployment of web_static

sudo apt update
sudo apt install -y nginx

sudo mkdir -p /data/web_static/shared
sudo mkdir -p /data/web_static/releases/test
content='<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>'

echo "$content" | sudo tee /data/web_static/releases/test/index.html

sudo ln -sf /data/web_static/releases/test  /data/web_static/current

sudo chown -R ubuntu:ubuntu /data/

nginx_config="/etc/nginx/sites-enabled/default"

sudo printf %s "server {
    listen 80 default_server;
    listen [::]:80 default_server;

    add_header X-Served-By $HOSTNAME;

    root   /var/www/html;

    index  index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    error_page 404 /404.html;
    location /404 {
      root /var/www/html;
      internal;
    }
}" | sudo tee "$nginx_config" > /dev/null

sudo service nginx restart
