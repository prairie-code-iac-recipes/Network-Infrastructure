resource "aws_vpc" "default" {
  cidr_block             = "${var.vpc_cidr_block}"
  enable_dns_support     = true
  enable_dns_hostnames   = true

  tags = {
    Name                 = "${var.group_tag} Default"
    Group                = "${var.group_tag}"
    Description          = "${var.description_tag}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name                 = "${var.group_tag} Default"
    Group                = "${var.group_tag}"
    Description          = "${var.description_tag}"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.default.default_route_table_id}"

  route {
    cidr_block           = "0.0.0.0/0"
    gateway_id           = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name                 = "${var.group_tag} Default"
    Group                = "${var.group_tag}"
    Description          = "${var.description_tag}"
  }
}

resource "aws_subnet" "private" {
  count                  = "${length(var.availability_zones)}"
  vpc_id                 = "${aws_vpc.default.id}"
  cidr_block             = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + count.index + 2)}"

  availability_zone      = "${var.availability_zones[count.index]}"

  tags = {
    Description          = "${var.description_tag}"
    Group                = "${var.group_tag}"
    Name                 = "${var.group_tag} Private #${count.index + 1}"
    Scope                = "private"
  }
}

resource "aws_subnet" "public" {
  count                  = "${length(var.availability_zones)}"
  vpc_id                 = "${aws_vpc.default.id}"
  cidr_block             = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + count.index + 1)}"

  availability_zone      = "${var.availability_zones[count.index]}"

  tags = {
    Description          = "${var.description_tag}"
    Group                = "${var.group_tag}"
    Name                 = "${var.group_tag} Public #${count.index + 1}"
    Scope                = "public"
  }
}

resource "aws_route_table_association" "private" {
  count                  = "${length(aws_subnet.private.*.id)}"

  subnet_id              = "${aws_subnet.private[count.index].id}"
  route_table_id         = "${aws_default_route_table.default.id}"
}

resource "aws_route_table_association" "public" {
  count                  = "${length(aws_subnet.public.*.id)}"

  subnet_id              = "${aws_subnet.public[count.index].id}"
  route_table_id         = "${aws_default_route_table.default.id}"
}
