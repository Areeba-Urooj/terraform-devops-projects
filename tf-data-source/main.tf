terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-north-1"
}
data "aws_ami" "name" {
  most_recent = true
  owners = ["amazon"]
}
output "aws-ami" {
  value = data.aws_ami.name.id
}
data "aws_security_group" "name" {
  tags = {
    mywebserver = "http"
  }
}
output "aws-security-group" {
  value = data.aws_security_group.name.id
}
data "aws_vpc" "name" {
  tags = {
    ENV = "PROD"
    Name = "my-vpc"
  }
}
output "vpc-id" {
  value = data.aws_vpc.name.id
}
data "aws_availability_zone" "names" {
  state = "available"
}
output "aws-zones" {
  value = data.aws_availability_zone.names.name
}
#To get the account details
data "aws_caller_identity" "name" {
   
}
#If you want to find region you're in
data "aws_region" "name" {
  
}
output "aws-region" {
  value = data.aws_region.name.id
}
output "aws-callers" {
  value = data.aws_caller_identity.name
}
resource "aws_instance" "WebServer_Stolkholme" {
  ami = data.aws_ami.name.id
  instance_type = "t3.micro"
  tags = {
    Name = "WebServer_Stolkholme"
  }
}