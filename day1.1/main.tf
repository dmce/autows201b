# Configure the AWS Provider
provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-2"
}

# Create a VPC
resource "aws_vpc" "arch_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
      Name = "f5-1.1"
  }
}

resource "aws_subnet" "mgmt" {
  vpc_id     = aws_vpc.arch_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "f5-mgmt"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.arch_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "f5-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.arch_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "f5-private"
  }
}