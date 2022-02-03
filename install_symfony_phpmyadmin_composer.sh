#!/bin/bash
# installs phpmyadmin, symfony and composer

echo "Installing dependencies..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install apache2 unzip software-properties-common -y

echo "Installing PHP..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install php8.0 libapache2-mod-php8.0 -y

echo "Installing MySQLServer..."
sudo apt install mysql-server -y
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';" | sudo mysql

echo "Downloading and installing PHPMyAdmin..."
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip
unzip phpMyAdmin-5.1.1-all-languages.zip
cd phpMyAdmin-5.1.1-all-languages/
sudo mkdir /var/www/html/phpmyadmin/
sudo mv * /var/www/html/phpmyadmin/

sudo apt install php8.0-mysql php8.0-xml -y
sudo systemctl restart apache2

echo "Removing downloaded folders"
cd ~
sudo rm -rf phpMyAdmin-5.1.1-all-languages.zip
sudo rm -rf phpMyAdmin-5.1.1-all-languages

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

composer //To check if composer is installed

wget https://get.symfony.com/cli/installer -O - | bash
sudo mv /home/${USER}/.symfony/bin/symfony /usr/local/bin/symfony

symfony # To check if symfony is installed

#git clone https://github.com/Cloud-Innovation-Partners/CloudTDMS_SaaS_Free.git
#cd CloudTDMS_SaaS_Free/

#vi .env.local # THEN Setup the database url

#composer install
#symfony console app:setup-database

#symfony serve -d
