####################################################
# Locals
####################################################
locals {
  private_db_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 3, 2)

  private_db_network_acl_rules = [
    {
      description         = "allow_egress_to_private_db"
      egress              = "true"
      protocol            = "-1"
      from_port           = "0"
      to_port             = "0"
      action              = "allow"
      cidr_block          = local.private_db_cidr_block
    },
    {
      description         = "allow_egress_tcp_response"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_ingress_5432_from_vpc"
      egress              = "false"
      protocol            = "tcp"
      from_port           = 5432
      to_port             = 5432
      action              = "allow"
      cidr_block          =  module.vpc.vpc_cidr_block
    },
    {
      description         = "allow_ingress_tcp_response_"
      egress              = "false"
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    }
  ]
}

####################################################
# Private Subnets Creation
####################################################
module "private_db_label" {
  source     = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  namespace  = var.namespace
  name       = "private_db"
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  enabled    = var.enable_label
}

module "private_db_subnets" {
  source                          = "git::https://github.com/rdansou/terraform-aws-modules.git//vpc/subnets?ref=master"
  create_private_subnet           = var.create_private_db_subnet
  namespace                       = var.namespace
  stage                           = var.stage
  name                            = "private_db"
  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = local.private_db_cidr_block
  az_ngw_ids                      = module.public_subnets.az_ngw_ids
  az_ngw_count                    = length(var.availability_zones)
  private_network_acl_rules       = local.private_db_network_acl_rules
  private_network_acl_rules_count = length(local.private_db_network_acl_rules)
  private_label_tags              = module.private_db_label.tags
  private_label_id                = module.private_db_label.id
}
