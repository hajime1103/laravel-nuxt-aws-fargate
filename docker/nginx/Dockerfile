FROM nginx:alpine

LABEL maintainer="Mahmoud Zalt <mahmoud@zalt.me>"

COPY nginx.conf /etc/nginx/

# If you're in China, or you need to change sources, will be set CHANGE_SOURCE to true in .env.

ARG CHANGE_SOURCE=false
RUN if [ ${CHANGE_SOURCE} = true ]; then \
    # Change application source from dl-cdn.alpinelinux.org to aliyun source
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
;fi

RUN apk update \
    && apk upgrade \
    && apk add --no-cache openssl \
    && apk add --no-cache bash \
    && adduser -D -H -u 1000 -s /bin/bash www-data

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf


# nginxコンテナ内でNuxtをSSRモードで立ち上げるためにnpmをインストールする
RUN apk add --update nodejs nodejs-npm

# TODO：Dockerが立ち上がったら自動でNuxtサーバを立ち上がるようにする

# ワーキングディレクトリの指定
WORKDIR /var/www

# githubからソースをcloneして配置する
#ADD clone {gitのURL} .

# Nuxtをビルドする準備をする
#RUN npm install

# Laravelを動作させるための準備をする
#RUN composer install

# foreverモジュールを入れて、Nuxtサーバをバックグラウンドで起動できるようにする
RUN npm install -g -y forever

# Nuxtコードをビルドする 
# 今はvolumeでソースをホストと共有してるためビルド時にはソースが存在しない
# 本番では実コードをコピーしてくるためここで実行するかstartup.shで実行するかは検討する
#RUN npm run build

ADD ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh
CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443
