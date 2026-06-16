terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#Configure the AWS Provider
provider "aws" {
    region ="eu-west-3"
}

#Create a VPC
resource "aws_vpc" "vpctest"{
  cidr_block = "10.0.0.0/16"

  tags = {
    Name ="Terraform VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpctest.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-3a"
  
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet"{
  vpc_id = aws_vpc.vpctest.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    Name ="private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpctest.id
  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpctest.id

  route {
    cidr_block="0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}
