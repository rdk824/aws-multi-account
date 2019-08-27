####################################################
# Locals
####################################################
locals {
  private_app_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 3, 1)

  private_app_network_acl_rules = [
    {
      description         = "allow_app_egress_http_to_the_world"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 80
      to_port             = 80
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_egress_https_to_the_world"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 443
      to_port             = 443
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_egress_5432_to_db"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 5432
      to_port             = 5432
      action              = "allow"
      cidr_block          = local.private_db_cidr_block
    },
    {
      description         = "allow_app_egress_tcp_response"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_ingress_http_from_public"
      egress              = "false"
      protocol            = "tcp"
      from_port           = 80
      to_port             = 80
      action              = "allow"
      cidr_block          =  local.public_cidr_block
    },
    {
      description         = "allow_ingress_https_from_public"
      egress              = "false"
      protocol            = "tcp"
      from_port           = 443
      to_port             = 443
      action              = "allow"
      cidr_block          =  local.public_cidr_block
    },
    {
      description         = "allow_all_ingress_from_private_app"
      egress              = "false"
      protocol            = "-1"
      from_port           = "0"
      to_port             = "0"
      action              = "allow"
      cidr_block          = local.private_app_cidr_block
    },
    {
      description         = "allow_ingress_tcp_response_from_the world"
      egress              = "false"
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    }
  ]
}
#==============================================
# Private Subnets Creation
#==============================================
module "private_app_label" {
  source     = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  namespace  = var.namespace
  name       = "private-app"
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  enabled    = var.enable_label
}

module "private_app_subnets" {
  source                          = "git::https://github.com/rdansou/terraform-aws-modules.git//vpc/subnets?ref=master"
  create_private_subnet           = var.create_private_app_subnet
  namespace                       = var.namespace
  stage                           = var.stage
  name                            = "private-app"
  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = local.private_app_cidr_block
  az_ngw_ids                      = module.public_subnets.az_ngw_ids
  az_ngw_count                    = length(var.availability_zones)
  private_network_acl_rules       = local.private_app_network_acl_rules
  private_network_acl_rules_count = length(local.private_app_network_acl_rules)
  private_label_tags              = module.private_app_label.tags
  private_label_id                = module.private_app_label.id
}
