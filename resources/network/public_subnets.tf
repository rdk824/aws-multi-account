####################################################
# Locals
####################################################
locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc_cidr_block, 3, 0)
  public_network_acl_rules = [
    {
      description         = "allow_egress_http_to_the_world"
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
      description         = "allow_egress_established_tcp_to_the_world"
      egress              = "true"
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_ingress_http_from_the_world"
      egress              = false
      protocol            = "tcp"
      from_port           = 80
      to_port             = 80
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_ingress_https_from_the_world"
      egress              = false
      protocol            = "tcp"
      from_port           = 443
      to_port             = 443
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    },
    {
      description         = "allow_ingress_ssh_from_the_world"
      egress              = false
      protocol            = "tcp"
      from_port           = 22
      to_port             = 22
      action              = "allow"
      cidr_block          =  "0.0.0.0/0"
    },
    {
      description         = "allow_all_ingress_established_tcp_from_the_world"
      egress              = false
      protocol            = "tcp"
      from_port           = 1024
      to_port             = 65535
      action              = "allow"
      cidr_block          = "0.0.0.0/0"
    }
  ]
}

#================================================================#
# Public Subnets
#================================================================#
module "public_label" {
  source     = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  namespace  = var.namespace
  name       = "public-subnet"
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  enabled    = var.enable_label
}

module "public_subnets" {
  source                          = "git::https://github.com/rdansou/terraform-aws-modules.git//vpc/subnets?ref=master"
  create_public_subnet            = var.create_public_subnet
  namespace                       = var.namespace
  stage                           = var.stage
  name                            = "public-subnet"
  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = local.public_cidr_block
  igw_id                          = module.vpc.igw_id
  create_nat_gateway              = var.create_nat_gateway
  public_network_acl_rules        = local.public_network_acl_rules
  public_network_acl_rules_count  = length(local.public_network_acl_rules)
  public_label_tags               = module.public_label.tags
  public_label_id                 = module.public_label.id

}
