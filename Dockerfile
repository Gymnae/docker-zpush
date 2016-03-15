FROM gymnae/webserverbase
MAINTAINER Gunnar Falk <docker@grundstil.de>

COPY /conf/nginx.conf /etc/nginx/

# install packages
RUN apk-install \
    mailcap

# ENV variables for z-push
ENV Z_PUSH_MAJOR 2.2
ENV Z_PUSH_MINOR 2.2.9


# download and install z-push from sources
RUN cd /tmp/ && \
    curl -O http://download.z-push.org/final/$Z_PUSH_MAJOR/z-push-$Z_PUSH_MINOR.tar.gz \
    && tar -xzvf z-push-$Z_PUSH_MINOR.tar.gz \
    && mkdir -p /usr/share/z-push \
    && cp -R z-push-$Z_PUSH_MINOR/* /usr/share/z-push/

# ready them folders
RUN mkdir /var/log/z-push /var/lib/z-push \
    && chown -R nginx:www-data /var/log/z-push /var/lib/z-push \
    && mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -LSs https://gitlab.com/davical-project/awl/repository/archive.tar.gz | tar xz
    
# copy config files
COPY /config/z-push/backend-config.conf /usr/share/z-push/backend/combined/config.php
COPY /config/z-push/backend-imap.conf /usr/share/z-push/backend/imap/config.php
COPY /config/z-push/backend-carddav.conf /usr/share/z-push/backend/carddav/config.php
COPY /config/z-push/backend-caldav.conf /usr/share/z-push/backend/caldav/config.php

# Export ports
EXPORT 80 443

# starting command
CMD [ "/init.sh" ]
