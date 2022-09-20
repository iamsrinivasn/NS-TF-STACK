### Terraform Provider Declaration ### 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
### Terraform Provider AWS ###
provider "aws" {
  region                  = var.AWS_REGION
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "tfadmin"
}

##  Create VPC
resource "aws_vpc" "webhost_vpc" {
    cidr_block = var.VPC_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_vpc"
      "Env" = var.AWS_ENV
    }
}

#  Create Public Subnets
resource "aws_subnet" "webhost_public_subnet" {
    vpc_id = aws_vpc.webhost_vpc.id
    cidr_block = var.PUBLIC_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_subnet_${var.PUBLIC_CIDR}",
      "Env" = var.AWS_ENV
    }
}

#  Create Private Subnets
resource "aws_subnet" "webhost_private_subnet" {
    vpc_id = aws_vpc.webhost_vpc.id
    cidr_block = var.PRIVATE_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_subnet_${var.PRIVATE_CIDR}",
      "Env" = var.AWS_ENV
    }
}

#  Create Internet Gateway
resource "aws_internet_gateway" "webhost_igw" {
    vpc_id = aws_vpc.webhost_vpc.id
    tags = {
      "Name" = "${var.AWS_ENV}_igw",
      "Env" = var.AWS_ENV
    }

}

# Create Private route table
resource "aws_route_table" "webhost_public_rt" {
  vpc_id = aws_vpc.webhost_vpc.id

  tags = {
    "Name" = "${var.AWS_ENV}_public_rt",
    "Env" = var.AWS_ENV
  }
}

# Create Private route table
resource "aws_route_table" "webhost_private_rt" {
  vpc_id = aws_vpc.webhost_vpc.id

  tags = {
    "Name" = "${var.AWS_ENV}_private_rt",
    "Env" = var.AWS_ENV
  }
}

# Associate public subnet to Public RT
resource "aws_route_table_association" "webhost_public_rt_associate" {
    subnet_id = aws_subnet.webhost_public_subnet.id
    route_table_id = aws_route_table.webhost_public_rt.id
}

# Associate private subnet to Private RT
resource "aws_route_table_association" "webhost_private_rt_associate" {
    subnet_id = aws_subnet.webhost_private_subnet.id
    route_table_id = aws_route_table.webhost_private_rt.id
}

#  Route to Internet Gateway
resource "aws_route" "webhost_public_rt" {
    route_table_id = aws_route_table.webhost_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webhost_igw.id
}