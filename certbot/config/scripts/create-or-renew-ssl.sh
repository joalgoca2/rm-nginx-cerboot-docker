#!/bin/bash

# Modes: Quiet (--quiet), Manual (--manual), Dry (--dry)
MODE=${CERTBOT_EXECUTION_MODE}
VERBOSITY=${CERTBOT_VERBOSITY}

NAME=${CERT_NAME}
DOMAINS=${CERT_DOMAINS}
KEY_SIZE=${CERT_KEY_SIZE}
EMAIL=${CERT_CONTACT_EMAIL}

if [ "$MODE" = "high" ] ; then
  VL="-vvv"
elif [ "$MODE" = "medium" ] ; then
  VL="-vv"
else
  VL="-v"
fi

# Cronjob quiet command
if [ "$MODE" = "quiet" ] ; then
  certbot certonly \
    --quiet \
    --dns-cloudflare \
    --dns-cloudflare-credentials /run/secrets/cloudflare-api-token \
    --rsa-key-size $KEY_SIZE \
    --cert-name $CERT_NAME \
    --staple-ocsp \
    --email $EMAIL \
    --agree-tos \
    --domains $DOMAINS \
    --max-log-backups 30 \
    --keep-until-expiring \
    --renew-with-new-domains
fi

# Manual interactive command
if [ "$MODE" = "manual" ] ; then
  certbot certonly \
    ${VL} \
    --dns-cloudflare \
    --dns-cloudflare-credentials /run/secrets/cloudflare-api-token \
    --rsa-key-size $KEY_SIZE \
    --cert-name $CERT_NAME \
    --staple-ocsp \
    --email $EMAIL \
    --agree-tos \
    --domains $DOMAINS \
    --max-log-backups 30 \
    --keep-until-expiring \
    --renew-with-new-domains
fi

# Dry run command
if [ "$MODE" = "dry" ] ; then
  certbot certonly \
    ${VL} \
    --dry-run \
    --non-interactive \
    --dns-cloudflare \
    --dns-cloudflare-credentials /run/secrets/cloudflare-api-token \
    --rsa-key-size $KEY_SIZE \
    --cert-name $CERT_NAME \
    --staple-ocsp \
    --email $EMAIL \
    --agree-tos \
    --domains $DOMAINS \
    --max-log-backups 30 \
    --keep-until-expiring \
    --renew-with-new-domains
fi
