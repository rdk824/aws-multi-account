
#===========================================================
# KMS KEY FOR ENCRYPTION
#===========================================================
module "kms_key_label" {
  source     = "git::https://github.com/rdansou/terraform-aws-modules.git//label?ref=master"
  enabled    = var.create_kms_key
  namespace  = var.namespace
  stage      = var.stage
  name       = "kms-key"
}

module "kms_key" {
  source                     = "git::https://github.com/rdansou/terraform-aws-modules.git//kms?ref=master"
  enabled                    = var.create_kms_key
  kms_key_alias              = var.kms_key_alias
  kms_key_label_tags         = module.kms_key_label.tags
}
