FROM gymnae/webserverbase
MAINTAINER Gunnar Falk <docker@grundstil.de>

# install packages
RUN apk-install \
    mailcap \
    php-posix \ 
    php-soap

# ENV variables for z-push
ENV Z_PUSH_MAJOR 2.2
ENV Z_PUSH_MINOR 2.2.9

# download and install z-push from sources
RUN cd /tmp && \
    curl -O http://download.z-push.org/final/$Z_PUSH_MAJOR/z-push-$Z_PUSH_MINOR.tar.gz \
    && tar -xzvf z-push-$Z_PUSH_MINOR.tar.gz \
    && mkdir -p /var/www/z-push \
    && cp -R z-push-$Z_PUSH_MINOR/* /var/www/z-push/
    
# copy config files - some standards are defined, many settings can be adjusted via env parameters
COPY /config/z-push/config.conf /var/www/z-push/config.php
COPY /config/z-push/backend-config.conf /var/www/z-push/backend/combined/config.php
COPY /config/z-push/backend-imap.conf /var/www/z-push/backend/imap/config.php
COPY /config/z-push/backend-carddav.conf /var/www/z-push/backend/carddav/config.php
COPY /config/z-push/backend-caldav.conf /var/www/z-push/backend/caldav/config.php

# copy webserver config
COPY /config/nginx.conf /etc/nginx/
COPY /config/php-fpm.conf /etc/php/

# Export ports
EXPOSE 80 443

# volume 
VOLUME /media/z-push

# prepare init script for start
ADD init.sh /init.sh
RUN chmod +x /init.sh

# starting command
CMD [ "/init.sh" ]
