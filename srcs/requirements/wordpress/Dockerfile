FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    php \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp 

# Copy WordPress setup script
COPY /tools/wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

# Use entrypoint to configure WP before launching php-fpm
ENTRYPOINT ["/usr/local/bin/wp-config.sh"]