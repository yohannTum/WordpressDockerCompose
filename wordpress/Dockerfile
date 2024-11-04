ARG PHP_VERSION
FROM wordpress:${PHP_VERSION} as wordpress

# Custom php and wp version
ARG PHP_VERSION
FROM php:${PHP_VERSION} as custom
ARG WORDPRESS_VERSION

# install utilities
RUN apt update
RUN apt install -y wget unzip libnss3-tools vim iputils-ping less

# php extensions dependencies
RUN apt install -y libfreetype-dev libjpeg62-turbo-dev libpng-dev
RUN docker-php-ext-configure gd && docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-configure mysqli && docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-enable pdo_mysql

# Apache config
COPY --chown=www-data:www-data config/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY --chown=www-data:www-data config/apache.conf /etc/apache2/conf-available/z-app.conf
RUN a2enmod rewrite remoteip && a2enconf z-app

# Installing wordpress with a specific version
WORKDIR /tmp
RUN wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.zip
RUN unzip wordpress-${WORDPRESS_VERSION}.zip
WORKDIR /var/www/html
RUN cp -r /tmp/wordpress/* .
COPY --chown=www-data:www-data ./config/wp-config.php .
COPY --chown=www-data:www-data ./.build/files/wp-content/ wp-content/

FROM custom as dev
WORKDIR /var/www/html
# Installing wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && cp wp-cli.phar /usr/local/bin/wp && echo "alias wp='wp --allow-root'" > ~/.bashrc
COPY --chown=www-data:www-data config/wp-cli.yml .

# You can add updated plugins by copying them like so :
# COPY plugins/myplugin /var/www/html/wp-content/plugins/myplugin

# Copy the script and set permissions
COPY --chmod=755 docker-wordpress-entrypoint.sh /usr/local/bin/docker-wordpress-entrypoint.sh
ENTRYPOINT ["docker-wordpress-entrypoint.sh"]
