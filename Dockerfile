FROM ubuntu:18.04
MAINTAINER Gna "gna@student.42seoul.kr"

#install nginx
RUN apt-get update && apt-get install -y nginx

#install php7.2-fpm
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install ca-certificates apt-transport-https -y
RUN apt-get install wget -y
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get install php7.2-fpm -y

#setting nginx and php
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
COPY ./srcs/index.php /var/www/html/

#install mysql and make wordpress database
RUN apt-get update && apt-get install mariadb-server php-mysql -y
COPY ./srcs/mysql.sql /docker-entrypoint-initdb.d/
RUN /usr/sbin/service mysql start && touch /var/run/mysqld/mysqld.sock && chown mysql /var/run/mysqld/mysqld.sock
RUN service mysql restart && mysql -u root < /docker-entrypoint-initdb.d/mysql.sql

#install mbstring and mysqli
RUN apt-get update && apt-get install php-mbstring -y
RUN apt-get install php7.2-mbstring -y
RUN apt-get install php-gettext -y
RUN phpenmod mbstring
RUN apt-get install php7.2-mysql -y
RUN phpenmod mysqli

#install phpmyadmin
COPY ./srcs/php.ini /etc/php/7.2/fpm/php.ini
RUN apt-get install phpmyadmin -y 
RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

#install wordpress
WORKDIR /usr/share/nginx/html/
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -zxvf latest.tar.gz
RUN rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /usr/share/nginx/html/wordpress/wp-config.php
RUN mkdir -p /usr/share/nginx/html/wordpress/wp-content/uploads
RUN chown -R root:root /usr/share/nginx/html/wordpress/
RUN mv /usr/share/nginx/html/wordpress /var/www/html/

#set ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=KR/ST=Seoul/L=Seoul/O=42_School/OU=Gna/CN=www.example.com"
RUN chown -R root:root *
RUN chmod 755 -R *
RUN nginx -t

#service start
COPY ./srcs/start.sh /etc/
RUN chmod +x /etc/start.sh
CMD bash /etc/start.sh

EXPOSE 80 443
