pipeline {
    agent any

    stages {
        // Parar los servicios que ya existen o en todo caso hacer caso omiso
        stage('Parando los servicios...') {
            steps {
                bat '''
                    cd ADJ-demo-c
                    docker compose -p adj-demo-c down || exit /b 0
                '''
            }
        }

        // Eliminar las imágenes creadas por ese proyecto
        stage('Eliminando imágenes anteriores...') {
            steps {
                bat '''
                    for /f "tokens=*" %%i in ('docker images --filter "label=com.docker.compose.project=adj-demo-c" -q') do (
                        docker rmi -f %%i
                    )
                    if errorlevel 1 (
                        echo No hay imagenes por eliminar
                    ) else (
                        echo Imagenes eliminadas correctamente
                    )
                '''
            }
        }

        // Del recurso SCM configurado en el job, jala el repo
        stage('Obteniendo actualización...') {
            steps {
                checkout scm
            }
        }

        // Generar y copiar certificados SSL si no existen
        stage('Configurando certificados SSL...') {
            steps {
                bat '''
                    cd ADJ-demo-c
                    if not exist "certs\\letsencrypt\\live\\localhost\\fullchain.pem" (
                        echo Generando certificados SSL...
                        bash generate-ssl-certs.sh
                        echo Copiando certificados al volumen Docker...
                        docker run -d --name cert-copy -v certbot-conf:/certs alpine sleep 3600
                        docker exec cert-copy mkdir -p /certs/live/localhost
                        docker cp certs/letsencrypt/live/localhost/. cert-copy:/certs/live/localhost/
                        docker rm -f cert-copy
                        echo Certificados configurados exitosamente
                    ) else (
                        echo Los certificados ya existen, verificando en el volumen...
                        docker run --rm -v certbot-conf:/certs alpine sh -c "if [ ! -f /certs/live/localhost/fullchain.pem ]; then exit 1; fi" || (
                            echo Copiando certificados al volumen Docker...
                            docker run -d --name cert-copy -v certbot-conf:/certs alpine sleep 3600
                            docker exec cert-copy mkdir -p /certs/live/localhost
                            docker cp certs/letsencrypt/live/localhost/. cert-copy:/certs/live/localhost/
                            docker rm -f cert-copy
                        )
                    )
                '''
            }
        }

        // Construir y levantar los servicios
        stage('Construyendo y desplegando servicios...') {
            steps {
                bat '''
                    cd ADJ-demo-c
                    echo Verificando Docker...
                    docker version || (echo ERROR: Docker no esta disponible && exit 1)
                    echo Docker disponible, construyendo servicios...
                    docker compose up --build -d || (echo ERROR al levantar servicios && docker compose logs && exit 1)
                    echo Esperando que los servicios esten listos...
                    timeout /t 30 /nobreak
                    docker compose ps
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline ejecutado con éxito'
        }

        failure {
            echo 'Hubo un error al ejecutar el pipeline'
        }

        always {
            echo 'Pipeline finalizado'
        }
    }
}