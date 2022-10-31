#!/bin/bash
# Thsi script will automate the configurations for our nginx server
# sleep until ec2 is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# update and install nginx and openssl so that we can create ssl certitcates
apt-get update
apt-get install nginx openssl -y
service nginx start

mkdir /etc/nginx/certificate

# create ssl certificates to attach to our webserver
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/certificate/nginx-certificate.crt -keyout /etc/nginx/certificate/nginx.key -subj "/C=SA/ST=Gauteng/L=Pretoria/O=tech, Inc./OU=IT/CN=localhost"

# append config files for nginx on port 443 and allow http redirect to https
echo "
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        return 301 https://\$host\$request_uri;
}
server {
        listen 443 ssl default_server;
        listen [::]:443 ssl default_server;
        ssl_certificate /etc/nginx/certificate/nginx-certificate.crt;
        ssl_certificate_key /etc/nginx/certificate/nginx.key;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files \$uri \$uri/ =404;
        }
}
"> /etc/nginx/sites-available/default

service nginx restart