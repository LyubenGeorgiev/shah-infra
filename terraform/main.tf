terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 4.15.0"
    }
  }

  cloud {
    organization = "Shah"

    workspaces {
      name = "Shah"
    }
  }
}

provider "aws" {
  region = "us-central-1"
}

resource "aws_vpc" "shah-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  # tags = {
  #   Name = "shah-vpc"
  # }
  
}

# resource "aws_subnet" "my-control-plane-subnet" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = "10.0.1.0/24"
# }

# resource "aws_subnet" "my-worker-node-subnet" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = "10.0.2.0/24"
# }

# resource "aws_security_group" "my-control-plane" {
#   name        = "my-control-plane"
#   vpc_id     = aws_vpc.my-vpc.id
#   description = "Enable SSH access to the control plane"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "my-worker-nodes" {
#   name        = "my-worker-nodes"
#   vpc_id     = aws_vpc.my-vpc.id
#   description = "Enable SSH access to the worker nodes and allow pods to communicate with each other"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.my-control-plane.id]
#   }

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.1.0/24"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "my-master-node" {
#   ami           = "ami-0c59e07542028640f"
#   instance_type = "t2.micro"
#   subnet_id    = aws_subnet.my-control-plane-subnet.id

#   tags = {
#     Name = "my-master-node"
#   }

#   security_groups = [
#     aws_security_group.my-control-plane.id
#   ]
# }

# resource "aws_instance" "my-worker-node" {
#   ami           = "ami-0c59e07542028640f"
#   instance_type = "t2.micro"
#   subnet_id    = aws_subnet.my-worker-node-subnet.id

#   tags = {
#     Name = "my-worker-node"
#   }

#   security_groups = [
#     aws_security_group.my-worker-nodes.id
#   ]
# }

# resource "kubernetes_cluster" "my-cluster" {
#   master_instance_id = aws_instance.my-master-node.id
#   workers_instance_ids = [aws_instance.my-worker-node.id]
# }