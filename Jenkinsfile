pipeline{

    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('DOCKER_ACCOUNT')
        SSH_CREDENTIALS_ID = 'remote_credentials' // ID des credentials SSH dans Jenkins
        SERVER_IP = '192.168.1.124'
        USERNAME = 'larissa'
    }

    stages{
        stage('Install Dependencies'){
            steps{
                echo 'Installing js dependencies'
                sh 'npm install'
            }
        }

        stage('Test'){
            steps{
                echo 'Testing the project'
                sh 'npm test'
            }
        }

        stage('Build_Image'){
            steps{
                echo 'Building docker image'
                sh 'docker build -t matsandy/playlist:latest .'
            }
        }

        stage('Login') {
            steps{
                echo 'Logging dockerhub account'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Push') {
            steps{
                echo 'Push the image to dockerhub repository'
                sh 'docker push matsandy/playlist:latest'
            }
        }

        stage('K8S-Deploy') {
            steps{
                echo 'Deploy with kubernetes objects'
                sh 'kubectl apply -f playlist-k8s.yaml'
            	sh 'minikube service playlist-service'
		}
        }

        stage('Remote SSH') {
            steps {
                echo 'Pull the image from dockerhub and run it'
                sshagent(credentials: [SSH_CREDENTIALS_ID]) {
                  sh """
                      ssh -o StrictHostKeyChecking=no ${USERNAME}@${SERVER_IP} 'docker run -d -p 8080:8080 matsandy/playlist:latest'
                   """
                }
            }
        }
    }

    post{
        always{
            echo 'finished'
            sh 'docker logout'
        }
    }
}
