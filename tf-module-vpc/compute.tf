provider "aws" {
  region = "eu-north-1"
}
data "aws_availability_zones" "vpc-az" {
  state = "available"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "my-vpc"
  cidr = "10.0.0.0/16"  
  azs = data.aws_availability_zones.vpc-az.names
  public_subnets = [ "10.0.0.0/24" ]
  private_subnets = [ "10.0.1.0/24" ]

  tags = {
    Name = "vpc-module"
  }
}