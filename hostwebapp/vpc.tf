#main vpc
data "aws_availability_zones" "available"{}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames= "true"
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
#public subnet
resource "aws_subnet" "publicsubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone= "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.project_name}-publicsubnet1"
  }
}
#public subnet
resource "aws_subnet" "publicsubnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone= "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.project_name}-publicsubnet2"
  }
}
#private subnet
resource "aws_subnet" "privatesubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone= "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "${var.project_name}-privatesubnet1"
  }
}
#private subnet
resource "aws_subnet" "privatesubnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone= "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "${var.project_name}-publicsubnet2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.project_name}-internetgateway"
  }
}
# eip association

resource "aws_eip" "eip" {
  vpc      = true
  depends_on= [ "aws_internet_gateway.gw"]
}
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.publicsubnet1.id}"
  depends_on = ["aws_internet_gateway.gw"]

  tags = {
    Name = "${var.project_name}-nat"
  }
}

#route table
resource "aws_route_table" "publicroute" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  } }
resource "aws_route_table" "privateroute" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }  }
#route table association public

resource "aws_route_table_association" "puba" {
  subnet_id      = "${aws_subnet.publicsubnet1.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}
resource "aws_route_table_association" "pubb" {
  subnet_id      = "${aws_subnet.publicsubnet2.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}
# route  for private
resource "aws_route_table_association" "priva" {
  subnet_id      = "${aws_subnet.privatesubnet1.id}"
  route_table_id = "${aws_route_table.privateroute.id}"
}
resource "aws_route_table_association" "privb" {
  subnet_id      = "${aws_subnet.privatesubnet2.id}"
  route_table_id = "${aws_route_table.privateroute.id}"
}
