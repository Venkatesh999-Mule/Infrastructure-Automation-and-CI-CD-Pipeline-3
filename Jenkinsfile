pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mulevenkatesh/infra-pipeline"
        DOCKER_TAG   = "latest"
        KUBECONFIG   = "/var/lib/jenkins/.kube/config"
    }

    stages {

        stage('1. Checkout') {
            steps {
                echo 'Pulling code from GitHub...'
                checkout scm
            }
        }

        stage('2. Terraform - Provision Server') {
            steps {
                echo 'Provisioning AWS infrastructure with Terraform...'
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('3. Maven - Build and Test') {
            steps {
                echo 'Building with Maven...'
                sh 'mvn clean package'
            }
        }

        stage('4. Docker - Build Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('5. Docker - Push to DockerHub') {
            steps {
                echo 'Pushing to DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                }
            }
        }

        stage('6. Kubernetes - Rolling Deploy') {
            steps {
                echo 'Deploying to Kubernetes with rolling update...'
                sh 'kubectl apply -f k8s/deployment.yaml'
                sh 'kubectl apply -f k8s/service.yaml'
                sh 'kubectl rollout status deployment/infra-pipeline --timeout=90s'
            }
        }

        stage('7. Shell - Monitor Health') {
            steps {
                echo 'Running health monitor...'
                sh 'bash scripts/monitor.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline SUCCESS - app is live!'
        }
        failure {
            echo 'Pipeline FAILED - check logs above!'
        }
    }
}