resource "aws_vpc" "sumademo" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "sumademo"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     =  aws_vpc.sumademo.id
  cidr_block = var.subnet_cidr
  availability_zone =  format("%s%s", var.region, var.availability_zone)
  tags = {
    Name = "demo_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sumademo.id

  tags = {
    Name = "sumademo"
  }
}

resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.sumademo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "sumademo"
  }
}

resource "aws_route_table_association" "web-access" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.demo-route-table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.sumademo.id

  ingress {
    description      = "Accept all in VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = [var.subnet_cidr]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "salt1"
    from_port        = 4505
    to_port          = 4505
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "salt1"
    from_port        = 4506
    to_port          = 4506
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}