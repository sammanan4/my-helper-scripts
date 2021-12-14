#!/bin/bash
sudo apt update -y

sudo apt install apache2 -y
sudo apt install mysql-server -y

sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php8.0 libapache2-mod-php8.0 -y
sudo systemctl restart apache2

sudo apt update -y
sudo apt install phpmyadmin php8.0-mbstring php8.0-zip php8.0-gd php-json php8.0-curl -y
sudo phpenmod mbstring
sudo systemctl restart apache2

echo "Enter MySQL root password: \c"
read pass
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$pass';" | sudo mysql

sudo systemctl restart apache2
