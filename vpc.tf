#Sets up the VPC, subnets, route tables, and gateways.
resource "aws_vpc" "win24_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "win24_vpc"
  }
}

resource "aws_subnet" "win24_pub_sub" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.win24_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "win24_pub_sub-${count.index}"
  }
}

resource "aws_subnet" "win24_priv_sub" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.win24_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "win24_priv_sub-${count.index}"
  }
}

resource "aws_internet_gateway" "win24_igw" {
  vpc_id = aws_vpc.win24_vpc.id

  tags = {
    Name = "win24_igw"
  }
}

resource "aws_route_table" "win24_public_rt" {
  vpc_id = aws_vpc.win24_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.win24_igw.id
  }

  tags = {
    Name = "win24_public_rt"
  }
}

resource "aws_route_table_association" "win24_public_rta" {
  count          = length(aws_subnet.win24_pub_sub)
  subnet_id      = element(aws_subnet.win24_pub_sub[*].id, count.index)
  route_table_id = aws_route_table.win24_public_rt.id
}

resource "aws_nat_gateway" "win24_nat" {
  allocation_id = aws_eip.win24_nat_eip.id
  subnet_id     = element(aws_subnet.win24_pub_sub[*].id, 0)

  tags = {
    Name = "win24_nat"
  }
}

resource "aws_eip" "win24_nat_eip" {

}

resource "aws_route_table" "win24_private_rt" {
  vpc_id = aws_vpc.win24_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.win24_nat.id
  }

  tags = {
    Name = "win24_private_rt"
  }
}

resource "aws_route_table_association" "win24_private_rta" {
  count          = length(aws_subnet.win24_priv_sub)
  subnet_id      = element(aws_subnet.win24_priv_sub[*].id, count.index)
  route_table_id = aws_route_table.win24_private_rt.id
}





