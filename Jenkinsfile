pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "node-jenkins-demo"
        DOCKER_TAG = "${BUILD_NUMBER}"
        REGISTRY = "your-dockerhub-username" // Cambia esto por tu usuario de DockerHub
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'npm test'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    def customImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    
                    // También crear tag 'latest'
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker image...'
                script {
                    // Ejecutar contenedor para verificar que funciona
                    sh """
                        docker run -d --name test-container -p 3001:3000 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        sleep 10
                        curl -f http://localhost:3001/health || exit 1
                        docker stop test-container
                        docker rm test-container
                    """
                }
            }
        }
        
        stage('Push to Registry') {
            when {
                branch 'main' // Solo hacer push desde la rama main
            }
            steps {
                echo 'Pushing image to Docker registry...'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        def image = docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}")
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
