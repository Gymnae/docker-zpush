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

#SED replacement
sed -i "" "s|${TIME_ZONE}|${TIME_ZONE:-Europe/London}|g"; \
        s/baz/zab/g; s/Alice/Joan/g' \
        /var/www/z-push/config.php


# Associative array where key represents a search string,
# and the value itself represents the replace string.
declare -A confs
confs=(
    [%%DB_USER%%]=bob
    [%%DB_NAME%%]=bobs_db
    [%%DB_PASSWORD%%]=hammertime
    [%%DB_HOST%%]=localhost
)

configurer() {
    # Loop the config array
    for i in "${!confs[@]}"
    do
        search=$i
        replace=${confs_wp[$i]}
        # Note the "" after -i, needed in OS X
        sed -i "" "s/${search}/${replace}/g" config.php
    done
}
configurer

# start php-fpm
php-fpm

# start nginx
nginx
