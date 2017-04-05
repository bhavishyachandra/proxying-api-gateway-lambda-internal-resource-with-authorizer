resource "aws_vpc" "proxy_poc_vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "proxy_poc_vpc"
    managed-by-terraform = 1
  }
}

resource "aws_internet_gateway" "proxy_poc_igw" {
  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"
}

resource "aws_route" "associate_igw_with_vpc_route_table" {
  route_table_id = "${aws_vpc.proxy_poc_vpc.default_route_table_id}"
  gateway_id = "${aws_internet_gateway.proxy_poc_igw.id}"
  destination_cidr_block = "${var.zero_address_default_route_cidr}"
}

resource "aws_subnet" "nat" {

  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"
  cidr_block = "${var.nat_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "nat"
    managed-by-terraform = 1
  }
}

resource "aws_subnet" "webserver" {

  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"
  cidr_block = "${var.webserver_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "webserver"
    managed-by-terraform = 1
  }
}

resource "aws_subnet" "lambda" {

  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"
  cidr_block = "${var.lambda_subnet_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "lambda"
    managed-by-terraform = 1
  }
}