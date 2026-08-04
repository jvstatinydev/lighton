# Authorization  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/authorization

---

## Page Summary

 outlined_flag

- 
 Access to the Google Play Android Developer API is authenticated using the OAuth 2.0 Web Server flow.

- 
 Before using the API, you need to set up an APIs Console project, create a client ID, and generate a refresh token.

- 
 Accessing the API involves using an access token in the Authorization header of your requests.

- 
 When an access token expires, you use the refresh token to obtain a new one without requiring user intervention.

This section contains instructions specific to the Google Play Developer API. See the
full OAuth2 documentation
for more details.

## Initial configuration

Access to the Google Play Android Developer API is authenticated using the
OAuth 2.0 Web Server
flow. Before you can use the API, you will need to set up an APIs Console
project, create a client ID and generate a refresh token.

### Creating an APIs Console project

- Go to the APIs Console and log in
with your Google Play Console account.

- Select Create project.

- Go to Services in the left-hand navigation panel.

- Turn the Google Play Android Developer API on.

- Accept the Terms of Service.

- Go to API Access in the left-hand navigation panel.

- Select Create an OAuth 2.0 client ID.

- On the first page, you will need to fill in the product name, but a logo
is not required. Note that your end users will not see the product name.

- On the second page, select web application and set the redirect URI and
Javascript origins. Both of these settings can be changed later.

- Select Create client ID.

### Generating a refresh token

- 
While logged in with your Google Play Console account, go to the
following URI:

```
https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/androidpublisher&response_type=code&access_type=offline&redirect_uri=...&client_id=...
```

Note: the redirect_uri
parameter must match the value registered with the client ID exactly, including
the trailing backslash, if present.

- 
Select Allow access when prompted.

- 
The browser will be redirected to your redirect URI with a code
parameter, which will look similar to 4/eWdxD7b-YSQ5CNNb-c2iI83KQx19.wp6198ti5Zc7dJ3UXOl0T3aRLxQmbwI.

- 
Exchange this code for an access and refresh token pair by sending a POST
request to https://accounts.google.com/o/oauth2/token with the
following fields set:

```

grant_type=authorization_code
code=<the code from the previous step>
client_id=<the client ID token created in the APIs Console>
client_secret=<the client secret corresponding to the client ID>
redirect_uri=<the URI registered with the client ID>

```

A successful response will contain your tokens in JSON format:

```

{
 "access_token" : "ya29.ZStBkRnGyZ2mUYOLgls7QVBxOg82XhBCFo8UIT5gM",
 "token_type" : "Bearer",
 "expires_in" : 3600,
 "refresh_token" : "1/zaaHNytlC3SEBX7F2cfrHcqJEa3KoAHYeXES6nmho"
}

```

## Accessing the API

Once you have generated the client credentials and refresh token, your servers
can access the API without an active login or human intervention.

### Using the access token

Servers can make calls to the API by passing the access token in the
Authorization header of the request:

```
Authorization: Bearer oauth2-token
```

### Using the refresh token

Each access token is only valid for a short time. Once the current access token
expires, the server will need to use the refresh token to get a new one. To do
this, send a POST request to https://accounts.google.com/o/oauth2/token with
the following fields set:

```

grant_type=refresh_token
client_id=<the client ID token created in the APIs Console>
client_secret=<the client secret corresponding to the client ID>
refresh_token=<the refresh token from the previous step>

```

A successful response will contain another access token:

```

{
 "access_token" : "ya29.AHES3ZQ_MbZCwac9TBWIbjW5ilJkXvLTeSl530Na2",
 "token_type" : "Bearer",
 "expires_in" : 3600,
}

```

The refresh token thus allows a web server continual access to the API without
requiring an active login to a Google account.
