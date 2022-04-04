FROM ubuntu:20.04

# Install system
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y build-essential 
RUN apt-get install -y software-properties-common
RUN apt-get install -y apache2 libapache2-mod-php
RUN apt-get install -y curl unzip php php-cli php-common
RUN apt install -y php-mbstring php-intl php-xml php-mysql
RUN apt-get install -y php-gd php-zip php-curl php-xmlrpc
RUN a2enmod rewrite

# Setup filesystem
COPY ./www /var/www/html:rw
COPY ./assets/vhost /etc/apache2/sites-available/000-default.conf
WORKDIR /var/www/html

# Execute
EXPOSE 80
CMD apachectl -D FOREGROUND
