locals {
  public_count              = var.create_public_subnet ? length(var.availability_zones) : 0
  public_nat_gateways_count = var.create_public_subnet && var.create_nat_gateway ? length(var.availability_zones) : 0
}

resource "aws_subnet" "public" {
  count                     = local.public_count
  vpc_id                    = var.vpc_id
  availability_zone         = element(var.availability_zones, count.index)
  map_public_ip_on_launch   = true
  cidr_block                = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = var.public_label_tags
}


resource "aws_network_acl" "public" {
  count      = var.create_public_subnet && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public.*.id

  tags       = var.public_label_tags
}

resource "aws_network_acl_rule" "public" {
  count          = var.create_public_subnet && signum(length(var.public_network_acl_id)) == 0 ? var.public_network_acl_rules_count : 0
  network_acl_id = aws_network_acl.public.0.id
  rule_number    = "10${count.index}"
  egress         = lookup(var.public_network_acl_rules[count.index], "egress")
  protocol       = lookup(var.public_network_acl_rules[count.index], "protocol")
  rule_action    = lookup(var.public_network_acl_rules[count.index], "action")
  cidr_block     = lookup(var.public_network_acl_rules[count.index], "cidr_block")
  from_port      = lookup(var.public_network_acl_rules[count.index], "from_port")
  to_port        = lookup(var.public_network_acl_rules[count.index], "to_port")
}

resource "aws_route_table" "public" {
  count  = local.public_count
  vpc_id = var.vpc_id

  tags = var.public_label_tags
}

resource "aws_route" "public" {
  count                  = local.public_count
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_eip" "public" {
  count = local.public_nat_gateways_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  count         = local.public_nat_gateways_count
  allocation_id = element(aws_eip.public.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }

  tags = var.public_label_tags
}
