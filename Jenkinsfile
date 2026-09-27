pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running project tests...'
                bat 'node --check app\\app.js'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                bat 'docker build -t typing-speed-test .'
            }
        }

        stage('Push to GHCR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ghcr-creds', usernameVariable: 'GHCR_USER', passwordVariable: 'GHCR_TOKEN')]) {
                    echo 'Logging in to GHCR...'
                    bat 'echo %GHCR_TOKEN% | docker login ghcr.io -u %GHCR_USER% --password-stdin'

                    echo 'Tagging image for GHCR...'
                    bat 'docker tag typing-speed-test ghcr.io/pranesh07-52/typing-speed-test-devops:latest'

                    echo 'Pushing image to GHCR...'
                    bat 'docker push ghcr.io/pranesh07-52/typing-speed-test-devops:latest'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
