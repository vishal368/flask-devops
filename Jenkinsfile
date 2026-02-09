pipeline {
    agent any

    stages {
        stage("Clone Code") {
            steps {
                git branch: 'main', url: 'https://github.com/vishal368/flask-devops.git'
            }
        }

        stage("Build Docker Image") {
            steps {
                sh "docker build -t flaskapp:v1."
            }
        }

        stage("Deploy to App Server") {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no ubuntu@98.80.9.144 '
                    docker stop flaskcontainer || true
                    docker rm flaskcontainer || true
                    docker run -d --name flaskcontainer -p 5000:5000 flaskapp:v1
                '
                """
            }
        }
    }
}