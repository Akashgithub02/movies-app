pipeline {
    agent any

    environment {
        // DockerHub credentials
        DOCKER_CREDENTIALS = 'docker-hub-credentials' // Jenkins credentials ID
        IMAGE_NAME = 'movies-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}" // Using the build number as the image tag
        DOCKER_REGISTRY = 'kotharkarakash4775' // DockerHub username
        GITHUB_CREDENTIALS = 'github-credentials'
    }

    parameters {
        string(name: 'DOCKER_TAG', defaultValue: "${env.BUILD_NUMBER}", description: 'Enter tag for the Docker image')
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull the latest code from the repository
                git branch: 'main', credentialsId: GITHUB_CREDENTIALS, url: 'https://github.com/Akashgithub02/movies-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${params.DOCKER_TAG} ."
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    // Login to DockerHub with Jenkins credentials securely
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }
        stage('Trivy Vulnerability Scan') {
            steps {
                script {
                    // Scan the Docker image for vulnerabilities using Trivy
                    sh "trivy image ${DOCKER_REGISTRY}/${IMAGE_NAME}:${params.DOCKER_TAG} --format json --output /tmp/vulnerability-report.json"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${params.DOCKER_TAG}"
                }
            }
        }
    }

     post {
        success {
            echo "Docker image has been successfully pushed to the registry."
            echo "Trivy vulnerability scan results:"
            sh "cat /tmp/vulnerability-report.json"
        }
        failure {
            echo "The pipeline failed. Please check the logs."
        }
    }
}
