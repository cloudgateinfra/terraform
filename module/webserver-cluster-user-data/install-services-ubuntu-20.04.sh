#!/bin/bash

#This script provisions a webserver on a EC2 instance running ubuntu 20.04

# Add Yarn apt repo
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Update, Upgrade, Install
apt update
apt upgrade -y
apt install -y apache2 yarn mysql-client aspell-en #npm installed via nvm via ami image for web cluster
apt install -y \
    php \
    libapache2-mod-php \
    php-mysql \
    php-bcmath \
    php-gd \
    php-igbinary \
    php-intl \
    php-ldap \
    php-msgpack \
    php-pspell \
    php-redis \
    php-soap \
    php-ssh2 \
    php-zip \
    php-dom \
    php-curl \
    php-mbstring
a2enmod ssl
a2enmod rewrite
a2enmod headers
a2enmod brotli
#a2enmod http2 #http2 does not work with mod_php
systemctl restart apache2

#Install cli53
wget "https://github.com/barnybug/cli53/releases/download/0.8.18/cli53-linux-amd64"
chmod +x cli53-linux-amd64
mv cli53-linux-amd64 /usr/local/bin/cli53

#Remove identifying headers
echo "ServerSignature Off" > /etc/apache2/conf-available/zzz-response-headers.conf
echo "ServerTokens Prod" >> /etc/apache2/conf-available/zzz-response-headers.conf
echo "Header unset X-Generator" >> /etc/apache2/conf-available/zzz-response-headers.conf
echo "Header unset X-Powered-By" >> /etc/apache2/conf-available/zzz-response-headers.conf
a2enconf zzz-response-headers

#Block HTTP Host injection vulns
echo "UseCanonicalName On" > /etc/apache2/conf-available/zzz-host-injection.conf
echo "Header unset X-Forwarded-Host" >> /etc/apache2/conf-available/zzz-host-injection.conf
a2enconf zzz-host-injection

#Block Directory Listing
echo "<Directory /var/www>" > /etc/apache2/conf-available/zzz-indexes.conf
echo "  Options -Indexes" >> /etc/apache2/conf-available/zzz-indexes.conf
echo "</Directory>" >> /etc/apache2/conf-available/zzz-indexes.conf
a2enconf zzz-indexes.conf

#Enable default vhosts
a2dissite default.conf
a2dissite default-ssl.conf
mv /etc/apache2/sites-available/default.conf /etc/apache2/sites-available/000-default.conf
mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
a2ensite 000-default.conf
a2ensite 000-default-ssl.conf

#Restart Apache
systemctl restart apache2

#Install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

#Setup user and group permissions.
usermod -g www-data ubuntu
echo "umask 002" >> /home/ubuntu/.profile
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chmod 600 /home/ubuntu/.ssh/id_rsa
