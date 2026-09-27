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
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
