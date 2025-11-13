module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"
  name = "vpc-para-terraform-spring"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a","us-east-1b"]
  public_subnets = ["10.0.100.0/24","10.0.101.0/24"]
  enable_vpn_gateway =  true
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  name = "Reglas para spring"
  vpc_id = module.vpc.vpc_id
  description = "Security Group para proyecto Terraform"
  ingress_rules = ["https-443-tcp", "ssh-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}
