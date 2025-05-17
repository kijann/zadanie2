pipeline {
    agent {
        label 'prod'
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
                        sh 'mvn clean test'
                    }
                }
                
            
        stage('Building jar file using maven') {
            steps {
                dir('zadanie2') {
                    sh 'mvn clean package -DskipTests=true'
                }
            }
        }
        
        stage('Build docker image') {
            steps {
                dir('zadanie2') {
                    script {
                        docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}", "-f Dockerfile .")
                    }
                }
            }
        }

        stage('Push docker image') {
            steps {
                script{
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                        docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").push()
                    }
                }
            }
        }
        
        stage ('Build docker service') {
            steps {
                sh """
                    docker-compose -f docker-compose-dev.yml stop zadanie2 || true
                    docker-compose -f docker-compose-dev.yml rm -f zadanie2 || true
                    docker-compose -f docker-compose-dev.yml up -d zadanie2
                """
                }
            }
        
        }
    }
}