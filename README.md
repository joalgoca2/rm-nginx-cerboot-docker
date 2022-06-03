# rm-nginx-cerboot-docker

# docker command
```bash

```

Los secreats tiene que tener permiso 600, solo para el due;o del archivo

# Setup

- docker-network
    - Ejecutar docker-compose up -d
- Redireccionar NS's a cloudflare
- cerbot
    - Actualizar .env
    - Ejecutar docker-compose up -d
- nginx
    - Crear entropia archivo dhparams-4096.pem
        ```bash
        $ openssl dhparam -dsaparam -out dhparam-4096.pem 4096
        ```
    - Descomentar en archivo config/globals/ssl.conf
        ssl_dhparam                 /etc/nginx/dhparams-4096.pem;
    - Remplazar en ssl.conf  dir_path_domain por la ruta generda en cerbot "Se puede encontrar en el .env de cerbot"
    - Renombrar archivo config/site-available/subdomain.domain.com
    - Actualizar archivo renombrado con el dominio o subdominio a redireccionar
    - Crear link simbolico en config/site-enabled/subdomain.domain.com
        ```bash
        $ ln -s ../sites-available/subdominio.dominio.com subdominio.dominio.com
        ```
    - 
# Verificar configuracion de archivos sites-available

sudo docker exec -it nginx-container nginx -t
