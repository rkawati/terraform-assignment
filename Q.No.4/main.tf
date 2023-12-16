// CREATE VPC
resource "aws_vpc" "main" {
  cidr_block       =  var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "my_vpc"
  }
}
// PUBLIC SUBNETS
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  availability_zone = var.availability_zone
  cidr_block = var.public_cidr
}

// internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

  // PUBLIC ROUTE TABLE
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
}
// routes
resource "aws_route" "this_route_public" {
  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = var.destination_cidr
  gateway_id = aws_internet_gateway.igw.id
}

// rt association
resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

// ssh key

resource "aws_key_pair" "key" {
  key_name   = var.aws_key
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpyOqU+/bwGDAtFEItUyNV1TJe0HZdrfw7V/UXL29dSZv0CgJdXEdaEXKU0L5LkvJktg+RDOOv+0WABkni/3PoH/noy14/qF/VHzkiHatmI3NegEMLO1NKeuzjACZuK4KobMw7+TOjpknLjgMcX1HSonR6AWP8KnauQWgHbBYPoiLFAUaSr3MJGzIZ+/VcqSKN8a8WqwIK+MKpC2fiRg2vIsMqhkYl1ZI2mqGkFtO3j1l45GNDPbPjB9ZaQZkoCZ3vD7nL3VMC5kVzpY/1MgA7s51ddnZsCV9HbAWB3Lz1fPzFQ/CVJZDAPJ2wRUqyERZUOvR3IvkoGpdbi2QcAbUW/k7B916JspHZ+JO/Qj0lUYUKdWNaiI0nxRZSOtZ5aVFPzIZTS5j/9iqOLYWA9+cjpzIPn1xIh1NOA0V9GVhE3FgKLREQ1fZgj+h+Jj3losgWFSZSoPKgGdQbhhcmABY5Ahnm7AfGR+7LRY0jM87PLcAYL05YxR7/ptN/C0vZ/UM= root@LAPTOP-H278KEF6"
}
// security group

resource "aws_security_group" "sg_group" {
  name        = "allow_ssh"
  description = "Allow ssh in inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = var.ssh_port
    to_port          = var.ssh_port
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }
}
 
 
  // create ec2 instance
  resource  "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = "t2-micro"
  key_name = var.aws_key
  tags = {
    Name = "var.instance_name"
    
  }
}
