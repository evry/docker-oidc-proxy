local opts = {
    discovery = os.getenv("OID_DISCOVERY"),
}

-- call bearer_jwt_verify to validate bearer token from openid connect
local res, err = require("resty.openidc").bearer_jwt_verify(opts)

ngx.log(ngx.INFO, tostring(res))
ngx.log(ngx.INFO, tostring(err))


if err then
    ngx.status = 401
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. err)
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

ngx.log(ngx.INFO, "Authentication successful, setting Auth header...")
