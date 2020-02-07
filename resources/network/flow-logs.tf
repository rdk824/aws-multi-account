####################################################
# VPC Flow Logs
####################################################
module "flow_logs_label" {
  source     = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  namespace  = var.namespace
  name       = "flow_logs"
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  enabled    = var.enable_label
}

module "flow_logs" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//vpc/flow-logs"
  enable_flow_logs          = true
  vpc_id                    = module.vpc.vpc_id
  namespace                 = var.namespace
  stage                     = var.stage
  flow_logs_label_id        = module.flow_logs_label.id
  cwl_log_group_name        = module.cwl.log_group_arn
}

module "cwl" {
  source      = "git::https://github.com/rdansou/terraform-aws-modules.git//cloudwatch"
  name        = module.flow_logs_label.id
  tags        = module.flow_logs_label.tags
}
