pipeline {
    agent any
    stages {
        stage('Preparation') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
                    sh 'docker stop riserunning'
                    sh 'docker rm riserunning'
                }
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t rise-app .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker run -d --name riserunning -p 5001:8080 rise-app'
            }
        }
    }
}