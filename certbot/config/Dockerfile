ARG CERTBOT_IMAGE_TAG
FROM certbot/dns-cloudflare:${CERTBOT_IMAGE_TAG}

RUN apk add --no-cache bash curl

COPY ./scripts/* /srv/certbot/

ENTRYPOINT ["/bin/bash", "/srv/certbot/create-or-renew-ssl.sh"]
