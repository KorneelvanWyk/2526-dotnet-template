node {
    stage('Checkout') {
        checkout scm
    }
    stage('Preparation') {
        catchError(buildResult: 'SUCCESS') {
            sh 'docker stop riserunning'
            sh 'docker rm riserunning'
        }
    }
    stage('Build') {
        sh 'docker build -t rise-app .'
        sh 'docker run -d --name riserunning -p 5001:8080 rise-app'
    }
}