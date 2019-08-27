
#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}


  #===================================================#
  # Organization Configuration                        #
  #===================================================#
  module "organization" {
    source                   = "../../modules/organization"

    create_group                      = true
    #-- Password Policy
    create_prod_password_policy       = true
    create_dev_password_policy        = true
    create_root_password_policy       = true
    #-- Cross-account roles
    create_prod_cross_account_roles   = true
    create_dev_cross_account_roles    = true
    aws_org_account_ids               = var.aws_org_account_ids
    aws_region                        = var.aws_default_region
  }
