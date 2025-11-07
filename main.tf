terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
locals {
  nombre_workspace = terraform.workspace
  ruta_private_key = "/home/rusok/Documentos/DevOps/ejemploTerraform/clasesdevops.pem"
  nombre_key = "clasesdevops"
  usuario_ssh = "ubuntu"
}

resource "aws_instance" "mi_app_spring" {
  count = local.nombre_workspace == "prod" ? 2 : 1
  ami           = "ami-0023593d16b53b3e9"
  instance_type = "t3.micro"
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.security-group.security_group_id]
  associate_public_ip_address = true
  key_name = local.nombre_key
  tags = {
    Name    = format("%s-%s",local.nombre_workspace,count.index)
  }
  provisioner "remote-exec" {
    inline = ["echo 'Esperando conexión SSH de ${self.public_ip}'"]
    connection {
      type = "ssh"
      user = local.usuario_ssh
      private_key = file(local.ruta_private_key)
      host = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, --private-key ${local.ruta_private_key} main.yml"
  }
}

resource "aws_cloudwatch_log_group" "grupo_log_ec2" {
  for_each = var.nombres_servicios
  tags = {
    Environment = "prueba"
    Servicio = each.key
  }
  lifecycle {
    create_before_destroy = true
  }
}
