FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    php \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml 

# Copy WordPress setup script
COPY wp-config.sh /usr/local/bin/wp-config.sh
RUN chmod +x /usr/local/bin/wp-config.sh

# Use entrypoint to configure WP before launching php-fpm
ENTRYPOINT ["/usr/local/bin/wp-config.sh"]