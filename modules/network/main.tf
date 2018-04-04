### vpc - start ###

resource "aws_vpc" "env_vpc" {
  cidr_block           = "${var.vpc_subnet}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name      = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "env_igw" {
  vpc_id = "${aws_vpc.env_vpc.id}"
  tags {
    Name      = "${var.environment_name}-igw"
    Terraform = "true"
  }
}

### vpc - end ###


### nat gateways - start ###

resource "aws_eip" "env_nat_gw_eips" {
  count = "${length(var.availability_zones)}"
  vpc   = true
}

resource "aws_nat_gateway" "env_gws" {
  count         = "${length(var.availability_zones)}"
  allocation_id = "${element(aws_eip.env_nat_gw_eips.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.env_public_subnets_resource.*.id, count.index)}"
  tags {
    Name      = "${var.environment_name}-${var.availability_zones[count.index]}-nat-gw"
    Terraform = "true"
  }
}

### nat gateways - end ###


### subnets - start ###

resource "aws_subnet" "env_public_subnets_resource" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${var.availability_zones[count.index]}"
  vpc_id            = "${aws_vpc.env_vpc.id}"
  cidr_block        = "${element(var.public_subnets, count.index)}"
  tags {
    Name      = "${var.environment_name}-${var.availability_zones[count.index]}-public"
    Terraform = "true"
  }
}

resource "aws_subnet" "env_private_subnets_resource" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${var.availability_zones[count.index]}"
  vpc_id            = "${aws_vpc.env_vpc.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  tags {
    Name      = "${var.environment_name}-${var.availability_zones[count.index]}-private"
    Terraform = "true"
  }
}

### subnets - end ###


### route tables - start ###

resource "aws_route_table" "env_public_route_table" {
  vpc_id = "${aws_vpc.env_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.env_igw.id}"
  }
  tags {
    Name      = "${var.environment_name}-public"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "env_public_route_table_assoc" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.env_public_subnets_resource.*.id, count.index)}"
  route_table_id = "${aws_route_table.env_public_route_table.id}"
}

resource "aws_route_table" "env_private_route_tables" {
  count  = "${length(var.availability_zones)}"
  vpc_id = "${aws_vpc.env_vpc.id}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.env_gws.*.id, count.index)}"
  }
  tags {
    Name      = "${var.environment_name}-${var.availability_zones[count.index]}-private"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "env_private_route_tables_assoc" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${element(aws_subnet.env_private_subnets_resource.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.env_private_route_tables.*.id, count.index)}"
}

### route tables - end ###