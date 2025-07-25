terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.4.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
  backend "s3" {
    bucket = "webserver_bucket_12bc"
    key = "backend.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  # Configuration options
  region = "eu-north-1"
}