terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-central-1"
  profile = "881340943714_AWSPowerUserAccess"
}

resource "aws_vpc" "bachelor_vpc_01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "bachelor_vpc_01"
  }
}

resource "aws_subnet" "bachelor_subnet_01" {
  vpc_id            = aws_vpc.bachelor_vpc_01.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "bachelor_subnet_01"
  }
}

resource "aws_security_group" "bachelor_sg_01" {
  vpc_id = aws_vpc.bachelor_vpc_01.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bachelor_sg_01"
  }
}

resource "aws_instance" "bachelor_ec2_01" {
  ami                    = "ami-0b74f796d330ab49c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.bachelor_subnet_01.id
  vpc_security_group_ids = [aws_security_group.bachelor_sg_01.id]

  tags = {
    Name = "bachelor_ec2_01"
  }
}

