resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name      = local.vpc_name
    yor_name  = "my_vpc"
    yor_trace = "fb4ac15d-cb9a-4e72-a62f-1f451aca7218"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name      = local.public_subnet_name
    yor_name  = "public"
    yor_trace = "ca8d88f8-1560-4727-b244-50180e82221e"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name      = local.private_subnet_name
    yor_name  = "private"
    yor_trace = "40977849-1c43-4e96-8cd0-2c1116e22357"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name      = local.igw_name
    yor_name  = "gw"
    yor_trace = "79bc25fe-3f44-44b1-b33a-2cbc85c95207"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name      = local.rt_name
    yor_name  = "second_rt"
    yor_trace = "d628fa74-ddba-4a7b-99ed-aaa01aaaca71"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.second_rt.id
}