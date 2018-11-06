FROM ubuntu:14.04

MAINTAINER Lunar Logic <support@lunarlogic.com>

#Mongo PHP driver version

ENV MONGO_VERSION 3.0.14
ENV MONGO_PGP 3.0
ENV MONGO_PHP_VERSION 1.6.14

#Install php and dependenceis
ENV DEBIAN_FRONTEND noninteractive
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
#RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/$MONGO_VERSION multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-$MONGO_VERSION.list
RUN apt-get update
RUN apt-get -yq install curl git make apache2 libapache2-mod-php5 php5 php5-dev php5-gd php5-curl php5-mcrypt php-pear php-apc vim libssl-dev
RUN apt-get -yq install mongodb-server libsasl2-dev

RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN pecl install mongo-$MONGO_PHP_VERSION && \
    echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini && \
    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/cli/conf.d/mongo.ini && \
    ln -s /etc/php5/mods-available/mongo.ini /etc/php5/apache2/conf.d/mongo.ini && \
    ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/mcrypt.ini && \
    ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/mcrypt.ini

RUN a2enmod rewrite
RUN rm -f /etc/apache2/sites-enabled/000-default.conf

RUN mkdir /home/mongo

ADD run.sh /run.sh

VOLUME ["/var/log/apache2"]

EXPOSE 80

CMD ["/run.sh"]
