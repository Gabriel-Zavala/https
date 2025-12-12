#!/bin/bash

# Script para generar certificados SSL autofirmados para desarrollo local

echo "Generando certificados SSL autofirmados..."

# Crear directorio para certificados
mkdir -p certs/letsencrypt/live/localhost

# Generar clave privada
openssl genrsa -out certs/letsencrypt/live/localhost/privkey.pem 2048

# Generar certificado autofirmado (válido por 365 días)
# Crear archivo de configuración temporal
cat > /tmp/ssl.conf <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = MX
ST = State
L = City
O = ADJ-Demo
CN = localhost

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
EOF

openssl req -new -x509 -key certs/letsencrypt/live/localhost/privkey.pem \
    -out certs/letsencrypt/live/localhost/fullchain.pem \
    -days 365 \
    -config /tmp/ssl.conf \
    -extensions v3_req

# Crear keystore.p12 para Spring Boot
openssl pkcs12 -export \
    -in certs/letsencrypt/live/localhost/fullchain.pem \
    -inkey certs/letsencrypt/live/localhost/privkey.pem \
    -out certs/letsencrypt/live/localhost/keystore.p12 \
    -name "localhost" \
    -password pass:changeit

echo "Certificados generados exitosamente en: certs/letsencrypt/live/localhost/"
echo ""
echo "Archivos generados:"
echo "  - privkey.pem (clave privada)"
echo "  - fullchain.pem (certificado)"
echo "  - keystore.p12 (keystore para Spring Boot)"
echo ""
echo "Ahora copia estos certificados al volumen de Docker:"
echo "  docker cp certs/letsencrypt certbot-conf:/etc/letsencrypt"

