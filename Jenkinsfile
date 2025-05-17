pipeline {
    agent {
        node {
            label 'built-in' 
        }
    }

    tools {
        maven 'maven-3.8.6' 
    }

    environment {
        DOCKER_IMAGE_NAME = 'zadanie2'
        DOCKER_IMAGE_TAG = 'latest'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10')) 
        disableConcurrentBuilds() 
        timeout(time: 5, unit: 'MINUTES') 
    }

    stages {
        stage('Prepare Environment') {
            steps {
                cleanWs()
                checkout scm
            }
        }

        stage('Test Code') {
            steps {
                dir('zadanie2') {
                    sh 'mvn -B clean test'
                }
            }
        }

        stage('Build JAR File') {
            steps {
                dir('zadanie2') {
                    sh 'mvn -B clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('zadanie2') {
                    script {
                        docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Service') {
            steps {
                dir('zadanie2') {
                    sh '''
                        docker-compose -f docker-compose-dev.yml stop zadanie2 || true
                        docker-compose -f docker-compose-dev.yml rm -f zadanie2 || true
                        docker-compose -f docker-compose-dev.yml up -d zadanie2
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline zakończony sukcesem!'
        }
        failure {
            echo 'Pipeline nie powiódł się.'
        }
    }
}
