resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.nat.id}"
}

resource "aws_route_table" "route_zero_address_to_igw" {

  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"

  route {
    cidr_block = "${var.zero_address_default_route_cidr}"
    gateway_id = "${aws_internet_gateway.proxy_poc_igw.id}"
  }

  tags {
    Name = "nat-to-internet-gateway"
    managed-by-terraform = true
  }
}

resource "aws_route_table_association" "associate_nat_with_igw" {

  subnet_id = "${aws_subnet.nat.id}"
  route_table_id = "${aws_route_table.route_zero_address_to_igw.id}"
}

resource "aws_route_table" "route_zero_address_to_nat" {

  vpc_id = "${aws_vpc.proxy_poc_vpc.id}"

  route {
    cidr_block = "${var.zero_address_default_route_cidr}"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "route_zero_address_to_nat"
    managed-by-terraform = true
  }
}

resource "aws_route_table_association" "associate_private_webserver_to_nat_route" {

  subnet_id = "${aws_subnet.webserver.id}"
  route_table_id = "${aws_route_table.route_zero_address_to_nat.id}"
}