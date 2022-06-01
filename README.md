# rm-nginx-cerboot-docker

# docker command
```bash

```

# Replace domain.com

```bash
$ find /test/ -name "*.*" -print | xargs sed -i 's/dominio.com/cambiardominio.com/g' "./"
```
./nginx/config/sites-available/subdomain.domain.com
./nginx/config/globals/secure.conf
./nginx/config/globals/ssl.conf
./nginx/.env
./certbot/init.letsendcrypt.sh
./cerbot/.env


# Crear Archivo
```bash
$ cd ./nginx/
$ openssl dhparam -dsaparam -out dhparam-4096.pem 4096
```