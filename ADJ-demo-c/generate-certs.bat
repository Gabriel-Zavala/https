@echo off
echo ========================================
echo Generando certificados SSL para localhost
echo ========================================

REM Crear directorio para certificados
if not exist "certs\live\localhost" mkdir "certs\live\localhost"

REM Generar clave privada
echo Generando clave privada...
openssl genrsa -out certs\live\localhost\privkey.pem 2048

REM Generar certificado autofirmado (válido por 365 días)
echo Generando certificado autofirmado...
openssl req -new -x509 -key certs\live\localhost\privkey.pem -out certs\live\localhost\fullchain.pem -days 365 -subj "/CN=localhost"

REM Crear fullchain.pem (para nginx)
copy certs\live\localhost\fullchain.pem certs\live\localhost\fullchain.pem

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
