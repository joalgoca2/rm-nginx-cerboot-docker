server {
  listen 80;
  listen [::]:80;
  server_name subdomain.domain.com;

  return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name subdomain.domain.com;

  #root /var/www/app;
  charset UTF-8;
  #index index.html

  ## GLOBALS ##
#  include /etc/nginx/globals/cache.conf;
#  include /etc/nginx/globals/drop.conf;
  include /etc/nginx/globals/secure.conf;
  include /etc/nginx/globals/ssl.conf;

#  if ($bad_referer) {
#    return 444;
#  }

  location / {
    set $upstream http://web-app-container:3000;

    if ($request_method = 'OPTIONS') {
      add_header 'Access-Control-Allow-Origin' '*';
      add_header 'Access-Control-Allow-Credentials' 'true';
      add_header 'Access-Control-Allow-Headers' 'Authorization,Accept,Origin,DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Content-Range,Range';
      add_header 'Access-Control-Allow-Methods' 'OPTIONS';
      add_header 'Access-Control-Max-Age' 1728000;
      add_header 'Content-Type' 'text/plain charset=UTF-8';
      add_header 'Content-Length' 0;
      return 204;
    }

    if ($request_method ~* "(GET|POST)") {
       add_header 'Access-Control-Allow-Origin' '*' always;
       add_header 'Access-Control-Allow-Credentials' 'true';
       add_header 'Access-Control-Allow-Methods' 'GET, POST';
       add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type';
    }

    #proxy_set_header Access-Control-Allow-Origin 'https://subdomain.domain.com';

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_http_version 1.1;

    # do not pass the CORS header from the response of the proxied server to the client
    #proxy_hide_header 'Access-Control-Allow-Origin';

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Scheme $scheme;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Ssl on;
    proxy_pass_request_headers on;
    proxy_redirect off;

    proxy_pass $upstream;
  }

  #location / {
  #  try_files $uri $uri/  =404;
  #}
}
