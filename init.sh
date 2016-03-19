#!/bin/sh

# ready them folders
mkdir -vp /media/z-push/log/z-push/ \
          /media/z-push/log/nginx/ \
          /media/z-push/log/php-fpm/ \
          /media/z-push/z-push/statedir/ \
	  /media/z-push/certs/

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
	-e "s|\$IMAP_SERVER|${IMAP_SERVER:-imapcontainer}|g"\
	-e "s|\$IMAP_PORT|${IMAP_PORT:-143}|g"\
	-e "s|\$SMTP_SERVER|${SMTP_SERVER:-smtpcontainer}|g"\
	-e "s|\$SMTP_AUTH|${SMTP_AUTH:-true}|g"\
	-e "s|\$IMAP_USER|${IMAP_USER:-editme}|g"\
	-e "s|\$IMAP_PW|${IMAP_PW:-passme}|g"\
	-e "s|\$SMTP_VERIFY_PEER|${SMTP_VERIFY_PEER:-true}|g"\
	-e "s|\$SMTP_VERIFY_PEER_NAME|${SMTP_VERIFY_PEER_NAME:-true}|g"\
	-e "s|\$SMTP_ALLOW_SELF_SIGNED|${SMTP_ALLOW_SELF_SIGNED:-false}|g"   \
       /var/www/z-push/backend/imap/config.php 
       
       # for backed carddav config
       sed -i.bak \
       -e "s|\$CARDDAV_PORT|${CARDDAV_PORT:-443}|g"\
       -e "s|\$CARDDAV_SERVER|${CARDDAV_SERVER:-carddavcontainer}|g"\
       -e "s|\$CARDDAV_PROT|${CARDDAV_PROT:-https}|g"\
       -e "s|/caldav.php/%u/|${CARDDAV_PATH:-/caldav.php/%u/}|g"  \
        /var/www/z-push/backend/carddav/config.php 
       
       # for backend caldav config
       sed -i.bak \
       -e "s|\$CALDAV_PORT|${CALDAV_PORT:-443}|g"\
       -e "s|\$CALDAV_SERVER|${CALDAV_SERVER:-caldavcontainer}|g"\
       -e "s|\$CALDAV_PROT|${CALDAV_PROT:-https}|g"\
       -e "s|/caldav.php/%u/|${CALDAV_PATH:-/caldav.php/%u/}|g"  \
       /var/www/z-push/backend/caldav/config.php 

# start php-fpm
php-fpm

# start nginx
nginx
