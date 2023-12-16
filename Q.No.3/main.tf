//create vpc
resource "aws_vpc" "test_vpc_project" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = var.test
  }
}
//public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.test_vpc_project.id
  cidr_block = var.public_cidr

  tags = {
    Name = "public_subnet1"
  }
}
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.test_vpc_project.id
  cidr_block = var.public_cidr2

  tags = {
    Name = "public_subnet2"
  }
}

//private subnet
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.test_vpc_project.id
  cidr_block = var.private_cidr1

  tags = {
    Name = "private_subnet1"
  }
}
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.test_vpc_project.id
  cidr_block = var.private_cidr2

  tags = {
    Name = "private_subnet2"
  }
}
//internet getway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc_project.id

  tags = {
    Name = var.internet
  }
}
//elastic ip
resource "aws_eip" "eip" {
  domain   = "vpc"
}

//public nat gateway
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet1.id

    tags = {
    Name = var.nat
  }
  }

//public route table
  resource "aws_route_table" "test_vpc_project_public_rt" {
  vpc_id = aws_vpc.test_vpc_project.id
  }

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc_project.id
  }

  resource "aws_route" "route_public1" {
  route_table_id            = aws_route_table.test_vpc_project_public_rt.id
  destination_cidr_block    = var.public_rt
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "route_private" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    =  var.private_rt
    gateway_id = aws_nat_gateway.NAT.id
}
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.test_vpc_project_public_rt.id
}
resource "aws_route_table_association" "private_subnet" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}