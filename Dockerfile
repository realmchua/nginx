############################################################################################################
# ██████╗░███████╗░█████╗░██╗░░░░░███╗░░░███╗██╗░██████╗  ██████╗░░█████╗░░█████╗░██╗░░██╗███████╗██████╗░ #
# ██╔══██╗██╔════╝██╔══██╗██║░░░░░████╗░████║╚█║██╔════╝  ██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗ #
# ██████╔╝█████╗░░███████║██║░░░░░██╔████╔██║░╚╝╚█████╗░  ██║░░██║██║░░██║██║░░╚═╝█████═╝░█████╗░░██████╔╝ #
# ██╔══██╗██╔══╝░░██╔══██║██║░░░░░██║╚██╔╝██║░░░░╚═══██╗  ██║░░██║██║░░██║██║░░██╗██╔═██╗░██╔══╝░░██╔══██╗ #
# ██║░░██║███████╗██║░░██║███████╗██║░╚═╝░██║░░░██████╔╝  ██████╔╝╚█████╔╝╚█████╔╝██║░╚██╗███████╗██║░░██║ #
# ╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝╚══════╝╚═╝░░░░░╚═╝░░░╚═════╝░  ╚═════╝░░╚════╝░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝ #
#                                                                                                          #
# ███╗░░██╗░██████╗░██╗███╗░░██╗██╗░░██╗                                                                   #
# ████╗░██║██╔════╝░██║████╗░██║╚██╗██╔╝                                                                   #
# ██╔██╗██║██║░░██╗░██║██╔██╗██║░╚███╔╝░                                                                   #
# ██║╚████║██║░░╚██╗██║██║╚████║░██╔██╗░                                                                   #
# ██║░╚███║╚██████╔╝██║██║░╚███║██╔╝╚██╗                                                                   #
# ╚═╝░░╚══╝░╚═════╝░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝                                                       Realm Chua  #
############################################################################################################

########## System Setting
FROM realmsg/alpine:stable

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/config", "/work", "/logs"]

ENV container=docker
ENV TIMEZONE="Asia/Singapore"
ARG VERSION
ARG BUILD_DATE
ARG ACME_EMAIL

RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >>/etc/apk/repositories

########## Maintainer Information
LABEL cloud.mylinuxbox.vendor="Realm Chua" \
      cloud.mylinuxbox.version=${VERSION} \
      cloud.mylinuxbox.build-date=${BUILD_DATE}

########## Dockerfile
RUN apk add --no-cache nginx \
    acme-client \
    php81-fpm \
    php81-mysqli \
    openssl \
    libressl

RUN cd /tmp && \
    git clone https://github.com/acmesh-official/acme.sh.git && \
    cd acme.sh && \
    ./acme.sh --install \
        --home /etc/acme.sh \
        --config-home /etc/acme.sh/data \
        --cert-home /etc/acme.sh/certs \
        --accountemail "${ACME_EMAIL}" \
        --accountkey /etc/acme.sh/acme.key \
        --accountconf /etc/acme.sh/acme.conf

RUN rm -rf /var/cache/apk/* \
    /tmp/acme.sh && \
    echo "${TIMEZONE}" >/etc/timezone && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php81/php.ini

RUN adduser -D -g 'www' www && mkdir /www && \
    chown -R www:www /var/lib/nginx && chown -R www:www /www && \
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig

COPY ["config/nginx.conf", "/etc/nginx/nginx.conf"]
COPY ["config/index.html", "config/phpinfo.php", "/www/"]

STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint/nginx.sh"]
CMD ["bash"]
