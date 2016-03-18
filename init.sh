#!/bin/sh

# ready them folders
mkdir -p /media/z-push/log/z-push \
        /media/z-push/log/nginx \
        /media/z-push/log/php-fpm
chown -R nginx:www-data /media/z-push/

if [ ! -d /usr/local/src ]; then
  mkdir -p /usr/local/src 
  cd /usr/local/src 
  curl -LSs https://gitlab.com/davical-project/awl/repository/archive.tar.gz | tar xz
fi

#SED replacements
        # for main config.php
        sed -i.back \
        "s|\$TIME_ZONE|${TIME_ZONE:-Europe/London}|g"  \
        /var/www/z-push/config.php
        
        # for backend imap config
       sed -i.bak \
       "s|\$IMAP_SERVER|${IMAP_SERVER:-imapcontainer}|g" ; \
       "s|\$IMAP_PORT|${IMAP_PORT:-143}|g" ; \
       "s|\$SMTP_SERVER|${SMTP_SERVER:-smtcontainer}|g" ; \
       /var/www/z-push/backend/imap/config.php 
       
       # for backed carddav config
       sed -i.bak \
       "s|\$CARDDAV_PORT|${CARDDAV_PORT:-443}|g" ; \
       "s|\$CARDDAV_SERVER|${CARDDAV_SERVER:-carddavserver}|g" ; \
       "s|\$CARDDAV_PROT|${CARDDAV_PROT:-https}|g" ; \
       "s|/caldav.php/%u/|${CARDDAV_PATH:-/caldav.php/%u/}|g" ; \
       /var/www/z-push/backend/carddav/config.php 
       
       # for backend caldav config
       sed -i.bak \
       "s|\$CALDAV_PORT|${CALDAV_PORT:-443}|g" ; \
       "s|\$CALDAV_SERVER|${CALDAV_SERVER:-caldavserver}|g" ; \
       "s|\$CALDAV_PROT|${CALDAV_PROT:-https}|g" ; \
       "s|/caldav.php/%u/|${CALDAV_PATH:-/caldav.php/%u/}|g" ; \
       /var/www/z-push/backend/caldav/config.php 

# start php-fpm
php-fpm

# start nginx
nginx
