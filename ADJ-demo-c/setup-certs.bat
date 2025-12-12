@echo off
echo ========================================
echo Configurando certificados en Docker
echo ========================================

REM Crear volumen si no existe
echo Creando volumen certbot-conf...
docker volume create certbot-conf 2>nul || echo Volumen ya existe

REM Crear contenedor temporal para copiar certificados
echo Copiando certificados al volumen Docker...
docker run --rm -v certbot-conf:/data -v "%CD%\certs:/certs" alpine sh -c "mkdir -p /data/live/localhost && cp -r /certs/live/localhost/* /data/live/localhost/ && ls -la /data/live/localhost/"

echo.
echo ========================================
echo Certificados copiados al volumen Docker!
echo ========================================
echo.
echo Ahora puedes ejecutar: docker-compose up --build -d
echo.
