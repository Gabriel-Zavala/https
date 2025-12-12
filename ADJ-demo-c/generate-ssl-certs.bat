@echo off
REM Script para generar certificados SSL autofirmados para desarrollo local en Windows

echo Generando certificados SSL autofirmados...

REM Crear directorio para certificados
if not exist "certs\letsencrypt\live\localhost" mkdir "certs\letsencrypt\live\localhost"

REM Verificar si OpenSSL está disponible
where openssl >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: OpenSSL no está instalado o no está en el PATH
    echo Por favor instala OpenSSL o usa Git Bash que incluye OpenSSL
    exit /b 1
)

REM Generar clave privada
openssl genrsa -out certs\letsencrypt\live\localhost\privkey.pem 2048

REM Generar certificado autofirmado (válido por 365 días)
openssl req -new -x509 -key certs\letsencrypt\live\localhost\privkey.pem -out certs\letsencrypt\live\localhost\fullchain.pem -days 365 -subj "/C=MX/ST=State/L=City/O=ADJ-Demo/CN=localhost"

REM Crear keystore.p12 para Spring Boot
openssl pkcs12 -export -in certs\letsencrypt\live\localhost\fullchain.pem -inkey certs\letsencrypt\live\localhost\privkey.pem -out certs\letsencrypt\live\localhost\keystore.p12 -name "localhost" -password pass:changeit

echo.
echo Certificados generados exitosamente en: certs\letsencrypt\live\localhost\
echo.
echo Archivos generados:
echo   - privkey.pem (clave privada)
echo   - fullchain.pem (certificado)
echo   - keystore.p12 (keystore para Spring Boot)
echo.
echo Ahora copia estos certificados al volumen de Docker:
echo   docker cp certs\letsencrypt certbot-conf:/etc/letsencrypt

