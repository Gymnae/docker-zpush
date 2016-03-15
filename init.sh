# ready them folders
mkdir -p /media/z-push/log/z-push \
        /media/z-push/log/nginx \
        /media/z-push/log/php-fpm
chown -R nginx:www-data /media/z-push/

if [ ! -d /usr/local/src ]; then
  mkdir -p /usr/local/src \
  cd /usr/local/src \
  curl -LSs https://gitlab.com/davical-project/awl/repository/archive.tar.gz | tar xz
fi

# start php-fpm
php-fpm

# start nginx
nginx
