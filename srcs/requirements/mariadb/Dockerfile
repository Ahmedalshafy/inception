FROM alpine:3.22

RUN apk add --no-cache mariadb \
	mariadb-client mariadb-server-utils && \
    rm -f /var/cache/apk/*

ADD tools/init.sh /
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]