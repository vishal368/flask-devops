terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Generate RSA key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair
resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# Save private key locally
resource "local_file" "my_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "my_key.pem"
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "my_sg"
  description = "Security group using Terraform"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0c398cb65a93047f2"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "jenkins_server"
  }
}

# App Server
resource "aws_instance" "app_server" {
  ami                    = "ami-0c398cb65a93047f2"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "app_server"
  }
}
