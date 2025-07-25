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
resource "aws_instance" "tf-var-server" {
  ami = "ami-09278528675a8d54e"
  instance_type = var.aws-instance-type

  root_block_device {
    delete_on_termination = true
    volume_size = var.ec2-config.v-size
    volume_type = var.ec2-config.v-type
  }
  tags = merge(var.tags, {
    Name = "tf-var-server"
  })
}