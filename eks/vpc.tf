resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
 
    tags = {
        eks-test = "test"
    }
}

resource "aws_subnet" "public_subnets" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.main.id
    cidr_block        = element(var.public_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "Public Subnet ${count.index + 1}"
        eks-test = "test"
    }
}

resource "aws_subnet" "private_subnets" {
    count             = length(var.private_subnet_cidrs)
    vpc_id            = aws_vpc.main.id
    cidr_block        = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)
 
    tags = {
        Name = "Private Subnet ${count.index + 1}"
        eks-test = "test"
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "test"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "test"
  }
}

resource "aws_route_table_association" "internet_access" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.main.id
}

resource "aws_eip" "main" {
  vpc = true

  tags = {
    Name = "test"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "test"
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  nat_gateway_id         = aws_nat_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}