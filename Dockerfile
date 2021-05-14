FROM alpine:edge

EXPOSE 8080
COPY . /ocr-fileformat
WORKDIR /ocr-fileformat
RUN apk add --no-cache openjdk8-jre php7 php7-json php7-openssl python3 py-lxml py-future git make ca-certificates wget bash gcc libc-dev \
    && update-ca-certificates \
    && make install \
    && cp docker.config.php web/config.local.php \
    && sed -i '/^upload_max_filesize/ s/=.*$/= 100M/' /etc/php7/php.ini \
    && sed -i 's/;extension=php_openssl.dll/extension=php_openssl.dll/' /etc/php7/php.ini \
    && mv web /ocr-fileformat-web \
    && rm -rf /ocr-fileformat \
    && apk del git make wget gcc libc-dev
# Disable POST upload limit
sed -i 's,post_max_size = 8M,post_max_size = 0,' /etc/php7/php.ini
VOLUME /data
WORKDIR /data
CMD php7 -S $(hostname -i):8080 -t /ocr-fileformat-web
