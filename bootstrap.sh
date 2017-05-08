#!/bin/sh

# So, for some non-obvious reason nginx with OpenResty does not fetch resolver
# nameserver from /etc/resolv.conf by default. It is not possible to read this
# using Lua when starting Nginx either so we have to patch the config before
# Nginx starts.

set -e
#set -u

RESOLV_CONF=/etc/resolv.conf

NGX_DIR=/usr/local/openresty/nginx
NGX_CONF="${NGX_DIR}/conf/nginx.conf"

OPENRESTY_BIN_DIR=/usr/local/openresty/bin
OPENRESTY_BIN=${OPENRESTY_BIN_DIR}/openresty

if [ -z "${NAMESERVER}" ] && [ -f "${RESOLV_CONF}" ]; then
    export NAMESERVER=`cat ${RESOLV_CONF} \
                     | grep "nameserver" \
                     | awk '{print $2}' \
                     | tr '\n' ' '`
fi

if [ -n "${NAMESERVER}" ]; then
  echo "Nameserver is: ${NAMESERVER}"

  echo "Patching nginx config"
  sed -i "s/resolver.*/resolver ${NAMESERVER};/" "${NGX_CONF}"
fi

echo "Using nginx config:"
cat "${NGX_CONF}"

echo "Starting nginx:"
"${OPENRESTY_BIN}" -g "daemon off;"
