
module "vpc_label" {
  source          = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  namespace       = var.namespace
  name            = "vpc"
  stage           = var.stage
  delimiter       = var.delimiter
  attributes      = var.attributes
  tags            = var.tags
  enabled         = var.enable_label
}

module "vpc" {
  source          = "git::https://github.com/rdansou/terraform-aws-modules.git//vpc?ref=master"
  namespace       = var.namespace
  name            = "vpc"
  stage           = var.stage
  cidr_block      = var.cidr_block
  vpc_label_tags  = module.vpc_label.tags
}
