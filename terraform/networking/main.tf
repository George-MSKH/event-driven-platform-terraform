resource "aws_vpc" "main_vpc" {
  cidr_block = var.specific_vpc_cidr
}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}"
  }
}

resource "aws_subnet" "private_subnets_db" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.private_subnet_db_cidr)
  cidr_block = var.private_subnet_db_cidr[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-db-${count.index}"
  }
}

resource "aws_subnet" "private_subnets_app" {
  vpc_id = aws_vpc.main_vpc.id
  count = length(var.private_subnet_app_cidr)
  cidr_block = var.private_subnet_app_cidr[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-app-${count.index}"
  }
}

resource "aws_internet_gateway" "aws_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_eip" "eip" {
  count = length(var.public_subnet_cidr)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnet_cidr)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id

  depends_on = [ aws_internet_gateway.aws_gateway ]
}

resource "aws_route_table" "route_table_private_app" {
  count = length(aws_subnet.private_subnets_app)  
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
}

resource "aws_route_table" "route_table_private_db" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_gateway.id
  }
}

resource "aws_route_table_association" "route_table_assoc_private_app" {
  count = length(aws_subnet.private_subnets_app)
  subnet_id = aws_subnet.private_subnets_app[count.index].id
  route_table_id = aws_route_table.route_table_private_app[count.index].id
}

resource "aws_route_table_association" "route_table_assoc_private_db" {
  count = length(aws_subnet.private_subnets_db)
  subnet_id = aws_subnet.private_subnets_db[count.index].id
  route_table_id = aws_route_table.route_table_private_db.id
}

resource "aws_route_table_association" "route_table_assoc_public" {
  count = length(aws_subnet.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.route_table_public.id
}