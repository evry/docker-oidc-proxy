FROM openresty/openresty:1.11.2.3-alpine
MAINTAINER Hans Kristian Flaatten <hans.flaatten@evry.com>

ENV \
 SESSION_VERSION=2.15 \
 HTTP_VERSION=0.10 \
 OPENIDC_VERSION=1.3.1 \
 JWT_VERSION=0.1.10

RUN \
 apk update && apk upgrade && apk add curl && \
 cd /tmp && \
 curl -sSL https://github.com/bungle/lua-resty-session/archive/v${SESSION_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/pintsized/lua-resty-http/archive/v${HTTP_VERSION}.tar.gz | tar xz  && \
 curl -sSL https://github.com/pingidentity/lua-resty-openidc/archive/v${OPENIDC_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/SkyLothar/lua-resty-jwt/releases/download/v${JWT_VERSION}/lua-resty-jwt-${JWT_VERSION}.tar.gz | tar xz && \
 cp -r /tmp/lua-resty-session-${SESSION_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-http-${HTTP_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-openidc-${OPENIDC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-jwt-${JWT_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 rm -rf /tmp/* && \
 mkdir -p /usr/local/openresty/nginx/conf/hostsites/ && \
 true

COPY bootstrap.sh /usr/local/openresty/bootstrap.sh
COPY nginx /usr/local/openresty/nginx/

ENTRYPOINT ["/usr/local/openresty/bootstrap.sh"]
