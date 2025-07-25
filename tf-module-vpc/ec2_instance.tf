module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "single-instance"
  ami = "ami-09278528675a8d54e"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name = "ec2-instance-module"
    Environment = "dev"
  }
}