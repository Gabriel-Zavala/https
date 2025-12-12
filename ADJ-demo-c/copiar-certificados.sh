#!/bin/bash

echo "Copiando certificados al volumen de Docker..."

# Crear contenedor temporal
docker run --rm -v certbot-conf:/certs alpine sh <<'EOF'
mkdir -p /certs/live/localhost
EOF

# Copiar archivos individualmente
docker cp certs/letsencrypt/live/localhost/fullchain.pem $(docker create -v certbot-conf:/certs alpine):/certs/live/localhost/fullchain.pem
docker cp certs/letsencrypt/live/localhost/privkey.pem $(docker create -v certbot-conf:/certs alpine):/certs/live/localhost/privkey.pem
docker cp certs/letsencrypt/live/localhost/keystore.p12 $(docker create -v certbot-conf:/certs alpine):/certs/live/localhost/keystore.p12

# Verificar
docker run --rm -v certbot-conf:/certs alpine ls -la /certs/live/localhost/

echo "Certificados copiados exitosamente!"

