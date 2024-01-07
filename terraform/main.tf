###### root/main.tf

module "eks" {
  source                  = "./modules/eks"
  aws_public_subnet       = module.vpc.aws_public_subnet
  vpc_id                  = module.vpc.vpc_id
  cluster_name            = "module-eks-${random_string.suffix.result}"
  endpoint_public_access  = true
  endpoint_private_access = false
  public_access_cidrs     = ["0.0.0.0/0"]
  node_group_name         = "cloudquicklabs"
  scaling_desired_size    = 1
  scaling_max_size        = 1
  scaling_min_size        = 1
  instance_types          = ["t3.small"]
  key_pair                = "TestKeyPair"
}

module "vpc" {
  source                  = "./modules/vpc"
  tags                    = "cloudquicklabs"
  instance_tenancy        = "default"
  vpc_cidr                = "10.0.0.0/16"
  access_ip               = "0.0.0.0/0"
  public_sn_count         = 2
  public_cidrs            = ["10.0.1.0/24", "10.0.2.0/24"]
  map_public_ip_on_launch = true
  rt_route_cidr_block     = "0.0.0.0/0"

}

# terraform {
#   required_providers {
#     aws = {
#     source  = "hashicorp/aws"
#     version = "~> 4.15.0"
#     }
#   }

#   cloud {
#     organization = "Shah"

#     workspaces {
#       name = "Shah"
#     }
#   }
# }

# provider "aws" {
#   region = "us-central-1"
# }

# resource "aws_vpc" "shah-vpc" {
#   cidr_block       = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support = true

#   tags = {
#     Name = "shah-vpc"
#   }
# }

# resource "aws_subnet" "kubernetes-subnet" {
#   vpc_id      = aws_vpc.shah-vpc.id
#   cidr_block  = "10.0.1.0/24"
#   tags = {
#     Name = "kubernetes-pvt"
#   }
# }

# resource "aws_internet_gateway" "kubernetes-igw" {
#   vpc_id = aws_vpc.shah-vpc.id
#   tags = {
#     Name = "kubernetes-igw"
#   }
# }

# resource "aws_route_table" "kubernetes-rt" {
#   vpc_id = aws_vpc.shah-vpc.id 

#   tags = {
#     Name = "kubernetes-rt"
#   }
# }

# resource "aws_route" "route-to-igw" {
#   route_table_id            = aws_route_table.kubernetes-rt.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id                = aws_internet_gateway.kubernetes-igw.id
# }

# resource "aws_route_table_association" "subnet-association" {
#   route_table_id = aws_route_table.kubernetes-rt.id
#   subnet_id      = aws_subnet.kubernetes-subnet.id
# }

# resource "aws_security_group" "kubernetes-sg" {
#   name        = "shah-kubernetes"
#   description = "shah kubernetes - security group"
#   vpc_id      = aws_vpc.shah-vpc.id  # Replace with your VPC ID

#   tags = {
#     Name = "kubernetes-sg"
#   }
# }

# # Allow all traffic within the VPC CIDR (10.0.0.0/16)
# resource "aws_security_group_rule" "internal-traffic" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["10.0.0.0/16"]
# }

# # Allow all traffic within another CIDR block (e.g., 10.200.0.0/16)
# resource "aws_security_group_rule" "additional-internal-traffic" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["10.200.0.0/16"]
# }

# # Allow SSH (port 22) from anywhere
# resource "aws_security_group_rule" "ssh-access" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# # Allow TCP traffic on port 6443 (common for Kubernetes API server) from anywhere
# resource "aws_security_group_rule" "kubernetes-api" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = 6443
#   to_port           = 6443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# # Allow HTTP traffic (port 80) from anywhere
# resource "aws_security_group_rule" "https-access" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# # Allow ICMP (ping) from anywhere
# resource "aws_security_group_rule" "icmp-access" {
#   security_group_id = aws_security_group.kubernetes-sg.id
#   type              = "ingress"
#   from_port         = -1
#   to_port           = -1
#   protocol          = "icmp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_lb" "kubernetes-nlb" {
#   name               = "kubernetes-nlb"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = [aws_subnet.kubernetes-subnet.id]
# }

# resource "aws_lb_target_group" "kubernetes-tg" {
#   name        = "kubernetes-tg"
#   port        = 6443
#   protocol    = "TCP"
#   target_type = "ip"
#   vpc_id      = aws_vpc.shah-vpc.id
# }

# resource "aws_lb_listener" "kubernetes-listener" {
#   load_balancer_arn = aws_lb.kubernetes-nlb.arn
#   port              = 80
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.kubernetes-tg.arn
#   }
# }

# data "aws_lb" "kubernetes-nlb" {
#   arn = aws_lb.kubernetes-nlb.arn
# }

# output "kubernetes_public_address" {
#   value = data.aws_lb.kubernetes-nlb.dns_name
# }

# resource "aws_instance" "kubernetes_controller" {
#   ami                    = "ami-0faab6bdbac9486fb"
#   instance_type          = "t2.micro"
#   key_name               = "kubernetes"
#   subnet_id              = aws_subnet.kubernetes-subnet.id
#   private_ip             = "10.0.1.10"
#   security_groups = [aws_security_group.kubernetes-sg.id]
#   associate_public_ip_address = true
#   source_dest_check = false

#   user_data = <<-EOF
#     #!/bin/bash
#     echo "name=controller" >> /etc/environment
#     EOF

#   ebs_block_device {
#     device_name = "/dev/sda1"
#     volume_size = 50
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "controller"
#   }
# }

# resource "aws_instance" "kubernetes_worker" {
#   ami                    = "ami-0faab6bdbac9486fb"
#   instance_type          = "t2.micro"
#   key_name               = "kubernetes"
#   subnet_id              = aws_subnet.kubernetes-subnet.id
#   private_ip             = "10.0.1.20"
#   security_groups = [aws_security_group.kubernetes-sg.id]
#   associate_public_ip_address = true
#   source_dest_check = false

#   user_data = <<-EOF
#     #!/bin/bash
#     echo "name=worker|pod-cidr=10.200.0.0/24" >> /etc/environment
#     EOF

#   ebs_block_device {
#     device_name = "/dev/sda1"
#     volume_size = 50
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "worker"
#   }
# }