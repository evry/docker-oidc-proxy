local opts = {
    redirect_uri = os.getenv("OIDC_REDIRECT_URI") or "/redirect_uri",
    discovery = os.getenv("OIDC_DISCOVERY_URL"),
    client_id = os.getenv("OIDC_CLIENT_ID"),
    client_secret = os.getenv("OIDC_CLIENT_SECRET"),
    token_endpoint_auth_method = os.getenv("OIDC_AUTH_METHOD") or "client_secret_basic",
    renew_access_token_on_expiry = os.getenv("OIDC_RENEW_ACCESS_TOKEN_ON_EXPIRY") ~= "false",
    scope = os.getenv("OIDC_AUTH_SCOPE") or "openid",
    group = os.getenv("OIDC_GROUP"),
    iat_slack = 600,
    use_pkce = os.getenv("OID_USE_PKCE") == "true"
}

-- call authenticate for OpenID Connect user authentication
local res, err, _target, session = require("resty.openidc").authenticate(opts)

ngx.log(ngx.INFO, tostring(res))
ngx.log(ngx.INFO, tostring(err))

ngx.log(ngx.INFO,
  "session.present=", session.present,
  ", session.data.id_token=", session.data.id_token ~= nil,
  ", session.data.authenticated=", session.data.authenticated,
  ", opts.force_reauthorize=", opts.force_reauthorize,
  ", opts.renew_access_token_on_expiry=", opts.renew_access_token_on_expiry,
  ", opts.use_pkce=", opts.use_pkce,
  ", try_to_renew=", try_to_renew,
  ", token_expired=", token_expired
)

if err then
    ngx.status = 500
    ngx.header.content_type = 'text/html';

    ngx.say("There was an error while logging in: " .. err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- https://stackoverflow.com/a/33511182
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

if opts.group and not(has_value(res.id_token.groups, opts.group)) then
    ngx.header.content_type = 'text/html';
    ngx.say("No are not authorized to access this resource.")
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

ngx.log(ngx.INFO, "Authentication successful, setting Auth header...")
ngx.req.set_header("Authorization", "Bearer "..session.data.enc_id_token)
