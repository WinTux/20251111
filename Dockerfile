FROM jenkins/jenkins:lts-jdk21
USER root
RUN apt update && apt install -y python3 python3-venv ansible
USER jenkins

