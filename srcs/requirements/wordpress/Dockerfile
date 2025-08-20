FROM alpine:3.19

RUN apk update && \
    apk add php83 php83-cli php83-fpm php83-mysqli \
    php83-json php83-openssl php83-curl php83-zlib \
    php83-xml php83-phar php83-intl php83-dom curl \
    wget tar openrc vim php83-cgi php83-mbstring \
    && ln -s /usr/bin/php83 /usr/bin/php

# Increase PHP memory limit for WordPress operations
RUN echo "memory_limit = 256M" >> /etc/php83/php.ini


RUN mkdir -p /run/php

# Copy the .conf in the html directory

COPY ./conf/www.conf /etc/php83/php-fpm.d

# COPY ./conf/wp-config.php /var/www/html/wordpress/wp-config.php

#we copy the script, give the right to launch it in local on our computer
COPY ./tools/create_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_wordpress.sh
ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]

# I need to install wp_cli command and put it in the right directory /usr/local/bin
RUN adduser -S www-data -G www-data \
  && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp \
  && chown www-data:www-data /usr/local/bin/wp

#We go the html directory
WORKDIR /var/www/html/

#We expose the 9000 port
EXPOSE 9000

#Launch PHP FPM in foreground and ignore deamonize from conf file (-F)
CMD ["/usr/sbin/php-fpm83", "-F"]
