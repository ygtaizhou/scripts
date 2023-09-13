#!/usr/bin/env bash

php_path="/Users/ygtaizhou/Downloads/php-8.2.10"

cd $php_path || exit

brew install libxml2 sqlite3 libiconv zlib gd curl oniguruma

export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig:/usr/local/opt/sqlite/lib/pkgconfig:/usr/local/opt/openssl@1.1/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/curl/lib/pkgconfig:/usr/local/opt/oniguruma/lib/pkgconfig:/usr/local/opt/readline/lib/pkgconfig:/usr/local/opt/argon2/lib/pkgconfig"

make clean

./configure --prefix=/usr/local/php \
  --enable-debug \
  --with-config-file-path=/usr/local/php/etc \
  --with-config-file-scan-dir=/usr/local/php/etc/conf.d \
  --enable-fpm \
  --disable-cgi \
  --enable-option-checking=fatal \
  --with-iconv=/usr/local/opt/libiconv \
  --with-mhash \
  --with-pic \
  --enable-ftp \
  --enable-mbstring \
  --enable-mysqlnd \
  --with-password-argon2 \
  --with-pdo-sqlite \
  --with-sqlite3=/usr/local/opt/sqlite \
  --with-curl=/usr/local/opt/curl \
  --with-openssl \
  --with-readline=/usr/local/opt/readline \
  --with-zlib \
  --with-pear

make -j4
sudo make install