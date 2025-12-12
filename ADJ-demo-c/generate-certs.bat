@echo off
echo ========================================
echo Generando certificados SSL para localhost
echo ========================================

REM Crear directorio para certificados
if not exist "certs\live\localhost" mkdir "certs\live\localhost"

REM Crear archivo de configuracion OpenSSL
echo [req] > certs\live\localhost\ssl.conf
echo distinguished_name = req_distinguished_name >> certs\live\localhost\ssl.conf
echo x509_extensions = v3_req >> certs\live\localhost\ssl.conf
echo prompt = no >> certs\live\localhost\ssl.conf
echo. >> certs\live\localhost\ssl.conf
echo [req_distinguished_name] >> certs\live\localhost\ssl.conf
echo CN = localhost >> certs\live\localhost\ssl.conf
echo. >> certs\live\localhost\ssl.conf
echo [v3_req] >> certs\live\localhost\ssl.conf
echo keyUsage = keyEncipherment, dataEncipherment >> certs\live\localhost\ssl.conf
echo extendedKeyUsage = serverAuth >> certs\live\localhost\ssl.conf
echo subjectAltName = @alt_names >> certs\live\localhost\ssl.conf
echo. >> certs\live\localhost\ssl.conf
echo [alt_names] >> certs\live\localhost\ssl.conf
echo DNS.1 = localhost >> certs\live\localhost\ssl.conf
echo IP.1 = 127.0.0.1 >> certs\live\localhost\ssl.conf

REM Generar clave privada
echo Generando clave privada...
openssl genrsa -out certs\live\localhost\privkey.pem 2048

REM Generar certificado autofirmado con extensiones correctas (válido por 365 días)
echo Generando certificado autofirmado con extensiones correctas...
openssl req -new -x509 -key certs\live\localhost\privkey.pem -out certs\live\localhost\fullchain.pem -days 365 -config certs\live\localhost\ssl.conf -extensions v3_req

REM Generar keystore PKCS12 para Spring Boot
echo Generando keystore para Spring Boot...
openssl pkcs12 -export -in certs\live\localhost\fullchain.pem -inkey certs\live\localhost\privkey.pem -out certs\live\localhost\keystore.p12 -name "localhost" -password pass:changeit -noiter -nomaciter

echo.
echo ========================================
echo Certificados generados exitosamente!
echo ========================================
echo.
echo Ubicacion de los certificados:
echo - certs\live\localhost\privkey.pem
echo - certs\live\localhost\fullchain.pem
echo - certs\live\localhost\keystore.p12
echo.
echo Ahora copia estos archivos al volumen Docker certbot-conf
echo.
