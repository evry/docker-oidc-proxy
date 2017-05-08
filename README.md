# evry/oidc-proxy [![Image Layers](https://images.microbadger.com/badges/image/evry/oidc-proxy.svg)](https://microbadger.com/#/images/evry/oidc-proxy)

Docker Image for OpenID Connect proxy authentication. Useful for putting
services behind Keycloak and other OpenID Connect authentication.

This is Image used Nginx for proxying request and OpenResty with the
`lua-resty-openidc` library to handle OpenID Connect authentication.

!["Docker OIDC Proxy overview"](https://raw.githubusercontent.com/evry/docker-oidc-proxy/master/assets/overview.png "Docker OIDC Proxy overview")

## Supported tags and respective Dockerfile links

* [`latest`, (*Dockerfile*)](https://github.com/evry/docker-oidc-proxy/blob/master/Dockerfile)

## How to use this image

This proxy is controlled through environment variables, so there is no need to
mess with any configuration files unless you want to of course. The following
environment variables is used in this image:

* `OID_SESSION_SECRET`: secret value for cookie sessions
* `OID_SESSION_CHECK_SSI`: check SSI or not (`on` or `off`)
* `OID_SESSION_NAME`: cookie session name

* `OID_REDIRECT_PATH`: Redirect path after authentication
* `OID_DISCOVERY`: OpenID provider well-known discovery URL
* `OID_CLIENT_ID`: OpenID Client ID
* `OID_CLIENT_SECRET`: OpenID Client Secret

* `PROXY_HOST`: Host name of the service to proxy
* `PROXY_PORT`: Port of the service to proxy
* `PROXY_PROTOCOL`: Protofol to the service to proxy (`http` or `https`)

```
docker run \
  -e OID_DISCOVERY=https://my-auth-server/auth \
  -e OID_CLIENT_ID=my-client \
  -e OID_CLIENT_SECRET=my-secret \
  -e PROXY_HOST=my-service \
  -e PROXY_PORT=80 \
  -e PROXY_PROTOCOL=http \
  -p 80:80 \
  evry/oidc-proxy
```

## License

This Docker image is licensed under the [MIT License](https://github.com/evry/docker-oidc-proxy/blob/master/LICENSE).

Software contained in this image is licensed under the following:

* docker-openresty: [BSD 2-clause "Simplified" License](https://github.com/openresty/docker-openresty/blob/master/COPYRIGHT)
* lua-resty-http: [BSD 2-clause "Simplified" License](hhttps://github.com/openresty/docker-open://github.com/openresty/docker-openrttps://github.com/bungle/lua-resty-http/blob/master/LICENSE)
* lua-resty-jwt: [Apache License 2.0](https://github.com/pingidentity/lua-resty-jwt/blob/master/LICENSE.txt)
* lua-resty-openidc: [Apache License 2.0](https://github.com/pingidentity/lua-resty-openidc/blob/master/LICENSE.txt)
* lua-resty-session: [BSD 2-clause "Simplified" License](hhttps://github.com/openresty/docker-open://github.com/openresty/docker-openrttps://github.com/bungle/lua-resty-session/blob/master/LICENSE)

## Supported Docker versions

This image is officially supported on Docker version 1.12.

Support for older versions (down to 1.0) is provided on a best-effort basis.

## User Feedback

### Documentation

* [Docker](http://docs.docker.com)
* [nginx](http://nginx.org/en/docs/)
* [OpenResty](http://openresty.org/)
* [lua-resty-openidc](https://github.com/pingidentity/lua-resty-openidc#readme)

### Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue](https://github.com/evry/docker-oidc-proxy/issues).

### Contributing

You are invited to contribute new features, fixes, or updates, large or small;
we are always thrilled to receive pull requests, and do our best to process them
as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub
issue](https://github.com/evry/docker-oidc-proxy/issues), especially for more
ambitious contributions. This gives other contributors a chance to point you in
the right direction, give you feedback on your design, and help you find out if
someone else is working on the same thing.
