FROM gymnae/webserverbase
MAINTAINER Gunnar Falk <docker@grundstil.de>

COPY /conf/nginx.conf /etc/nginx/

# install packages
RUN apk-install \
    php-pecl-memprof \
    mailcap

# ready folders
RUN mkdir /var/log/z-push /var/lib/z-push \
    && chown -R nginx:www-data /var/log/z-push /var/lib/z-push
    && cd /usr/local/src \
    && curl -LSs https://gitlab.com/davical-project/awl/repository/archive.tar.gz | tar xz \

# z-push folder
VOLUME /var/www/z-push

# Export ports
EXPORT 80 443

CMD [ "/init.sh" ]
