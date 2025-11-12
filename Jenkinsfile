pipeline {
    agent any
    environment {
        // Variables globales
        APP_NAME = "ProySpring"
        JAR_PATH = "ProySpring/target/${APP_NAME}.jar"
        ANSIBLE_ROLE_PATH = "roles/springboot/files"
    }
    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build & Test') {
            steps {
                dir('ProySpring') {
                    sh '''
                    ./mvnw clean package -DskipTests=false
                    mv target/ProySpring-*.jar target/ProySpring.jar
                    '''
                }
            }
            post {
                success {
                    echo "Build and tests OK"
                }
                failure {
                    error("Fallaron los tests. Pipeline detenido.")
                }
            }
        }
        stage('Copy Jar to Ansible role') {
            steps {
                sh """
                cp ${JAR_PATH} ${ANSIBLE_ROLE_PATH}/ProySpring.jar
                ls -lh ${ANSIBLE_ROLE_PATH}
                """
            }
        }
        stage('Terraform Validate') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials'
                ]]) {
                    sh """
                    terraform init
                    terraform validate
                    terraform plan -out=tfplan
                    """
                }
            }
        }
        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                input message: "¿Aplicar cambios Terraform en PROD?"
                sh "terraform apply -auto-approve tfplan"
            }
        }
        stage('Deploy with Ansible') {
            steps {
                sh """
                ansible-playbook -i inventory main.yml
                """
            }
        }
    }
    post {
        success {
            echo "Pipeline completado correctamente"
        }
        failure {
            echo "Error en el pipeline"
        }
    }
}
