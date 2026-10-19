pipeline {
    agent any
    environment {
        STUDENT_NAME    = 'Ali'
        STUDENT_SURNAME = 'Anatbek'
        STUDENT_GROUP   = 'IT2-2309'
        STUDENT_ID      = '41505'
        IMAGE_NAME      = 'anatbek-ali-devops'
        CONTAINER_NAME  = 'anatbek-ali-container'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git log -1 --oneline'
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Student: $STUDENT_NAME $STUDENT_SURNAME"'
                sh 'echo "Group: $STUDENT_GROUP"'
                sh 'echo "Student ID: $STUDENT_ID"'
                sh 'chmod +x app/app.sh'
            }
        }
        stage('Test') {
            steps {
                sh 'test -f Dockerfile && test -f app/app.sh && test -f Anatbek_Ali_info.txt'
                sh 'echo "All checks passed"'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }
        stage('Docker Run') {
            steps {
                sh 'docker rm -f $CONTAINER_NAME || true'
                sh 'docker run --name $CONTAINER_NAME -e STUDENT_NAME -e STUDENT_SURNAME -e STUDENT_GROUP -e STUDENT_ID $IMAGE_NAME'
            }
        }
    }
    post {
        success { echo 'Pipeline finished successfully!' }
        failure { echo 'Pipeline failed!' }
    }
}
