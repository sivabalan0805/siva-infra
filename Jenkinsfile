pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Validate') {
            steps {
                sh 'python --version'
                sh 'go version'
                sh 'javac -version'
            }
        }
        stage('Build') {
            steps { sh 'docker compose build' }
        }
        stage('Test') {
            steps {
                sh 'python -m py_compile services/python-api/app.py'
                sh 'go test ./services/go-api/...'
                sh 'javac -d /tmp/java-api-build services/java-api/src/Main.java'
            }
        }
        stage('Deploy') {
            when { anyOf { branch 'develop'; branch 'test'; branch 'main' } }
            steps {
                script {
                    def environment = [develop: 'dev', test: 'test', main: 'prod'][env.BRANCH_NAME]
                    sh "terraform -chdir=infra/terraform init -input=false"
                    sh "terraform -chdir=infra/terraform apply -auto-approve -var-file=environments/${environment}.tfvars"
                }
            }
        }
    }
    post { always { sh 'docker compose down --remove-orphans || true' } }
}