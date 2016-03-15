FROM gymnae/webserverbase
MAINTAINER Gunnar Falk <docker@grundstil.de>

# install packages
RUN apk-install \
    mailcap

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
COPY /config/z-push/config.conf /var/www/z-push/backend/config.php
COPY /config/z-push/backend-config.conf /var/www/z-push/backend/combined/config.php
COPY /config/z-push/backend-imap.conf /var/www/z-push/backend/imap/config.php
COPY /config/z-push/backend-carddav.conf /var/www/z-push/backend/carddav/config.php
COPY /config/z-push/backend-caldav.conf /var/www/z-push/backend/caldav/config.php

# copy webserver config
COPY /conf/nginx.conf /etc/nginx/
COPY /conf/php-fpm.conf /etc/php/

# Export ports
EXPORT 80 443

# volume 
VOLUME /media/z-push

# starting command
CMD [ "/init.sh" ]
