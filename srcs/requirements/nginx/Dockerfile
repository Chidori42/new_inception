FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mycertificate.key \
    -out /etc/nginx/ssl/mycertificate.crt \
    -subj "/C=MA/ST=KHOURIBGA/L=KHOURIBGA/O=1337/OU=1337/CN=ael-fagr.42.fr" 


COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]