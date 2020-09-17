provider "aws" {
  version = "~> 3.0"
  region  = "eu-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.48.0"
  
  name = "f5-1.2"
  cidr = "10.0.0.0/16"

  azs = ["eu-west-2a"]
  private_subnets = ["10.0.3.0/24"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  tags = {
      Terraform = "true"
      Environment = "dev"
      UK-SE = "arch"
  }
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

output "my-ip" {
  value = "${chomp(data.http.myip.body)}/32"
}

resource "random_string" "password" {
  length  = 10
  special = false
}