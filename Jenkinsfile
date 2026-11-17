pipeline {
    agent any
    parameters {
        choice(name: 'TARGET', choices: ['staging', 'production'],
               description: 'Welk deel van de pipeline draaien?')
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    stages {
        stage('Checkout') {
            when { expression { params.TARGET == 'staging' } }
            steps {
                checkout scm
            }
        }
        stage('Preparation') {
            when { expression { params.TARGET == 'staging' } }
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'SUCCESS') {
                    sh 'docker stop riserunning'
                    sh 'docker rm riserunning'
                }
            }
        }
        stage('Build') {
            when { expression { params.TARGET == 'staging' } }
            steps {
                sh 'docker build -t rise-app .'
            }
        }
        stage('Deploy staging') {
            when { expression { params.TARGET == 'staging' } }
            steps {
                sh 'docker run -d --name riserunning -p 5001:8080 rise-app'
            }
        }
        stage('Test staging') {
            when { expression { params.TARGET == 'staging' } }
            steps {
                sh '''
                    APP_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' riserunning)
                    for i in $(seq 1 40); do
                        curl -sf -o /dev/null http://$APP_IP:8080/ && exit 0
                        sleep 3
                    done
                    exit 1
                '''
            }
        }        

        stage('Deploy production') {
            when { expression { params.TARGET == 'production' } }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dmz010-ssh',
                                                  usernameVariable: 'SSH_USER',
                                                  passwordVariable: 'SSHPASS')]) {
                    sh '''
                        sshpass -e ssh -o StrictHostKeyChecking=no $SSH_USER@$PROD_HOST \
                          "docker rm -f riserunning 2>/dev/null || true; \
                           rm -rf rise; \
                           git clone --branch main $DOTNET_REPO rise; \
                           cd rise && docker build -t rise-app . && \
                           docker run -d --name riserunning -p 5001:8080 rise-app"
                    '''
                }
            }
        }
        stage('Verify production') {
            when { expression { params.TARGET == 'production' } }
            steps {
                sh '''
                    for i in $(seq 1 40); do
                        curl -sf -o /dev/null http://$PROD_HOST:5001/ && exit 0
                        sleep 3
                    done
                    exit 1
                '''
            }
        }
    }
}