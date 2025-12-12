# Guía para Subir y Desplegar en Jenkins

## Paso 1: Preparar el Repositorio Git

### 1.1 Inicializar Git (si no está inicializado)
```bash
cd D:\ADJ-demo-c\ADJ-demo-c
git init
```

### 1.2 Agregar todos los archivos
```bash
git add .
```

### 1.3 Hacer el primer commit
```bash
git commit -m "Initial commit: Configuración completa del proyecto ADJ-demo-c"
```

## Paso 2: Subir a un Repositorio Remoto

### 2.1 Crear un repositorio en GitHub/GitLab/Bitbucket
- Ve a tu plataforma de Git (GitHub, GitLab, etc.)
- Crea un nuevo repositorio (puede estar vacío)
- Copia la URL del repositorio (ej: `https://github.com/tu-usuario/adj-demo-c.git`)

### 2.2 Conectar con el repositorio remoto
```bash
git remote add origin <URL_DEL_REPOSITORIO>
# Ejemplo: git remote add origin https://github.com/tu-usuario/adj-demo-c.git
```

### 2.3 Subir el código
```bash
git branch -M main
git push -u origin main
```

## Paso 3: Preparar el Servidor Jenkins

### 3.1 Crear la red Docker
En el servidor donde corre Jenkins, ejecuta:
```bash
docker network create --driver bridge adj-net
```

### 3.2 Crear los volúmenes Docker
```bash
docker volume create adj-volume
docker volume create certbot-conf
```

**Nota:** Si no tienes certificados SSL aún, puedes crear el volumen vacío. Los certificados se pueden agregar después.

## Paso 4: Configurar el Job en Jenkins

### 4.1 Crear un nuevo Pipeline Job
1. Ve a Jenkins → **New Item**
2. Ingresa un nombre (ej: `adj-demo-c`)
3. Selecciona **Pipeline**
4. Click en **OK**

### 4.2 Configurar el Pipeline
En la configuración del job:

1. **Pipeline section:**
   - **Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** `<URL_DEL_REPOSITORIO>`
   - **Credentials:** (agrega credenciales si el repo es privado)
   - **Branch:** `*/main` (o `*/master` según tu rama)
   - **Script Path:** `Jenkinsfile`

2. **Build Triggers (opcional):**
   - Puedes activar "Poll SCM" para builds automáticos
   - O "GitHub hook trigger" si usas GitHub

3. Click en **Save**

## Paso 5: Ejecutar el Pipeline

### 5.1 Ejecutar manualmente
1. Ve al job creado en Jenkins
2. Click en **Build Now**
3. Observa el progreso en **Build History**

### 5.2 Ver los logs
- Click en el build en ejecución
- Click en **Console Output** para ver los logs en tiempo real

## Paso 6: Verificar el Despliegue

Una vez completado el pipeline, verifica:

1. **Contenedores corriendo:**
   ```bash
   docker ps
   ```
   Deberías ver:
   - `adj-database`
   - `adj-client`
   - `adj-server`

2. **Acceder a la aplicación:**
   - Frontend: `http://localhost:3080`
   - Backend API: `https://localhost:8081/adj-api/test`

## Solución de Problemas Comunes

### Error: "Network adj-net not found"
```bash
docker network create --driver bridge adj-net
```

### Error: "Volume adj-volume not found"
```bash
docker volume create adj-volume
docker volume create certbot-conf
```

### Error: "SSL certificate not found"
Si no tienes certificados SSL configurados, puedes:
1. Modificar temporalmente `docker-compose.yml` para deshabilitar SSL
2. O generar certificados con certbot antes de ejecutar

### Error en la construcción
- Revisa los logs en Jenkins Console Output
- Verifica que Docker esté corriendo en el servidor Jenkins
- Asegúrate de que Maven y Node.js estén disponibles (si no usas Docker)

## Comandos Útiles

### Ver logs de contenedores
```bash
docker logs adj-server
docker logs adj-client
docker logs adj-database
```

### Detener todo
```bash
docker compose -p adj-demo-c down
```

### Reiniciar todo
```bash
docker compose -p adj-demo-c restart
```

