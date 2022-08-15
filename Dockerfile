FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION='7.4'

# Install system
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y apt-utils build-essential
RUN apt-get install -y software-properties-common

# Install PHP
RUN add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y php${PHP_VERSION}

# Install Apache
RUN apt-get install -y vim curl unzip apache2
RUN apt-get install -y libapache2-mod-php${PHP_VERSION}
RUN apt-get install -y php${PHP_VERSION}-cli php${PHP_VERSION}-common

# Install PHP extensions
RUN apt-get install -y php${PHP_VERSION}-gd php${PHP_VERSION}-zip
RUN apt-get install -y php${PHP_VERSION}-mysql php${PHP_VERSION}-xml
RUN apt-get install -y php${PHP_VERSION}-curl php${PHP_VERSION}-json
RUN apt-get install -y php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl
RUN apt-get install -y php${PHP_VERSION}-simplexml php${PHP_VERSION}-xmlrpc

# Start service
RUN a2enmod rewrite
RUN service apache2 restart

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

# Setup filesystem
COPY ./www /var/www/html:rw
COPY ./assets/vhost /etc/apache2/sites-available/000-default.conf
WORKDIR /var/www/html

# Execute
EXPOSE 80
CMD apachectl -D FOREGROUND
