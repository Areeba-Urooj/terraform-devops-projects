#Creating vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
#Creating subnets
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private-subnet"
  }
}
#Creating Internet Gateway
resource "aws_internet_gateway" "my-internet-gw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-internet-gw"
  }
}
#Creating RouteTable for IG
resource "aws_route_table" "my-routetable" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-internet-gw.id
  }
}

resource "aws_route_table_association" "public-subnet" {
route_table_id = aws_route_table.my-routetable.id
subnet_id = aws_subnet.public-subnet.id
}