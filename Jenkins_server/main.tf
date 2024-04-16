#vpc

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins_vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets

  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    name = "jenkin_subnets"
  }
}

#sg

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sgp"
  description = "Security group for custom port"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "putty"
      cidr_blocks = "0.0.0.0/0"
    },

  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    name = "jenkins-sg"
  }

}

#ec2

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins_server"
  instance_type               = var.instance_type
  ami                         = data.aws_ami.example.id
  key_name                    = "jenkins_eks"
  monitoring                  = true
  vpc_security_group_ids      = [module.vote_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  availability_zone           = data.aws_availability_zones.azs.names[0]
  user_data                   = file("jenkins_inst.sh")

  tags = {
    name        = "jenkins server install"
    Terraform   = "true"
    Environment = "dev"
  }
}
