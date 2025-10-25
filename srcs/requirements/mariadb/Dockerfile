FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y &&\
    apt-get install -y mariadb-server

COPY  /tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY  /tools/scrept.sh /scrept.sh 

RUN chmod +x /scrept.sh 
ENTRYPOINT ["./scrept.sh"]