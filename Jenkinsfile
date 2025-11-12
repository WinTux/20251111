pipeline {
    agent any
    tools {
        terraform 'Terraform_1.9'
    }
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
                ],file(credentialsId: 'clasesdevops-pem', variable: 'AWS_KEY_FILE')]) {
                    sh """
                    terraform init
                    terraform validate -var="ruta_private_key=${AWS_KEY_FILE}"
                    terraform plan -var="ruta_private_key=${AWS_KEY_FILE}" -out=tfplan
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
                withCredentials([
                   [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials'],
                   file(credentialsId: 'clasesdevops-pem', variable: 'AWS_KEY_FILE')
                ]){
                    sh """
                    terraform apply -auto-approve -var="ruta_private_key=${AWS_KEY_FILE}" tfplan
                    """
                }
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
