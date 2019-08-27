locals {
  private_count                   = var.create_private_subnet ? length(var.availability_zones) : 0
  private_route_count             = var.create_private_subnet ? var.az_ngw_count : 0
}

resource "aws_subnet" "private" {
  count             = local.private_count
  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = var.private_label_tags

}

resource "aws_network_acl" "private" {
  count      = var.create_private_subnet && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private.*.id

  tags       = var.private_label_tags
}

resource "aws_network_acl_rule" "private" {
  count = var.create_private_subnet && signum(length(var.private_network_acl_id)) == 0 ? var.private_network_acl_rules_count : 0

  network_acl_id = aws_network_acl.private.0.id
  rule_number    = "10${count.index}"
  egress         = lookup(var.private_network_acl_rules[count.index], "egress")
  protocol       = lookup(var.private_network_acl_rules[count.index], "protocol")
  rule_action    = lookup(var.private_network_acl_rules[count.index], "action")
  cidr_block     = lookup(var.private_network_acl_rules[count.index], "cidr_block")
  from_port      = lookup(var.private_network_acl_rules[count.index], "from_port")
  to_port        = lookup(var.private_network_acl_rules[count.index], "to_port")
}

resource "aws_route_table" "private" {
  count  = local.private_count
  vpc_id = var.vpc_id

  tags = var.private_label_tags
}

resource "aws_route_table_association" "private" {
  count          = local.private_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "default" {
  count                  = local.private_route_count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id         = element(var.az_ngw_ids, count.index)
  destination_cidr_block = "0.0.0.0/0"
}
