# Configuración de SSL/HTTPS para ADJ-demo-c

## Pasos para configurar HTTPS

### 1. Generar certificados SSL autofirmados

#### Opción A: Usando Git Bash (Windows)
```bash
bash generate-ssl-certs.sh
```

#### Opción B: Usando CMD/PowerShell (Windows)
```cmd
generate-ssl-certs.bat
```

**Nota:** Necesitas tener OpenSSL instalado. Si usas Git Bash, OpenSSL ya está incluido.

### 2. Copiar certificados al volumen de Docker

Después de generar los certificados, cópialos al volumen de Docker:

```bash
# Verificar que el volumen existe
docker volume inspect certbot-conf

# Si no existe, créalo
docker volume create certbot-conf

# Copiar los certificados al volumen
docker run --rm -v certbot-conf:/target -v "$(pwd)/certs/letsencrypt:/source" alpine sh -c "cp -r /source/* /target/"
```

**En Windows (CMD):**
```cmd
docker run --rm -v certbot-conf:/target -v "%CD%\certs\letsencrypt:/source" alpine sh -c "cp -r /source/* /target/"
```

**En Windows (PowerShell):**
```powershell
docker run --rm -v certbot-conf:/target -v "${PWD}\certs\letsencrypt:/source" alpine sh -c "cp -r /source/* /target/"
```

### 3. Verificar que los certificados estén en el volumen

```bash
docker run --rm -v certbot-conf:/certs alpine ls -la /certs/live/localhost/
```

Deberías ver:
- `fullchain.pem`
- `privkey.pem`
- `keystore.p12`

### 4. Ejecutar el pipeline en Jenkins

Una vez que los certificados estén en el volumen, ejecuta el pipeline en Jenkins y todo debería funcionar con HTTPS.

## Acceso a la aplicación

- **Frontend:** `https://localhost:3001` (redirige desde `http://localhost:3080`)
- **Backend API:** `https://localhost:8081/adj-api/test`

**Nota:** Como los certificados son autofirmados, tu navegador mostrará una advertencia de seguridad. Esto es normal en desarrollo. Puedes hacer clic en "Avanzado" y luego "Continuar" para acceder.

## Solución de problemas

### Error: "OpenSSL no está instalado"
- Instala OpenSSL o usa Git Bash que ya lo incluye
- En Windows, puedes descargar OpenSSL desde: https://slproweb.com/products/Win32OpenSSL.html

### Error: "Volume certbot-conf not found"
```bash
docker volume create certbot-conf
```

### Error: "No se pueden cargar los certificados"
Verifica que los certificados estén en el volumen:
```bash
docker run --rm -v certbot-conf:/certs alpine ls -la /certs/live/localhost/
```

