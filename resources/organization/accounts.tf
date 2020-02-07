
data "aws_caller_identity" "current" {}

locals {
  cross_account_params = [
    {
      role_name            = "AdminAccessRole"
      policy_name          = "AdminAccessPolicy"
      policy_file          = "${path.module}/iam-policy-files/admin_policy.json"
      principal_arn        = data.aws_caller_identity.current.account_id
    },
    {
      role_name            = "ReadOnlyAccessRole"
      policy_name          = "ReadOnlyAccessPolicy"
      policy_file          = "${path.module}/iam-policy-files/read_only_policy.json"
      principal_arn        = data.aws_caller_identity.current.account_id
    },
  ]
  cross_account_dev_params = [
    {
      role_name            = "DevAccessRole"
      policy_name          = "DevAccessPolicy"
      policy_file          = "${path.module}/iam-policy-files/power_user_policy.json"
      principal_arn        = data.aws_caller_identity.current.account_id
    },
  ]
}

#-------------------------------------------
### Organization Prod Account
#--------------------------------------------

##-- Cross Account Role
module "prod_cross_account_role" {
  source                         = "git::https://github.com/rdansou/terraform-aws-modules.git//organization/cross_account?ref=master"
  account_id                     = lookup(var.aws_org_account_ids, "prod")
  account_name                   = "production"
  aws_region                     = var.aws_region
  create_cross_account_roles     = var.create_prod_cross_account_roles
  cross_account_params           = local.cross_account_params
}

#-------------------------------------------
### Organization Dev Account
#--------------------------------------------
##-- Cross Account Role
module "dev_cross_account_role" {
  source                         = "git::https://github.com/rdansou/terraform-aws-modules.git//organization/cross_account?ref=master"
  account_id                     = lookup(var.aws_org_account_ids, "dev")
  account_name                   = "dev"
  aws_region                     = var.aws_region
  create_cross_account_roles     = var.create_dev_cross_account_roles
  cross_account_params           = concat(local.cross_account_params, local.cross_account_dev_params)
}


module "root_password_policy" {
  source                         = "git::https://github.com/rdansou/terraform-aws-modules.git//organization?ref=master"

  ##-- Password Policy
  create_password_policy         = var.create_root_password_policy
  allow_users_to_change_password = true
  hard_expiry                    = false
  max_password_age               = 0
  minimum_password_length        = 12
  password_reuse_prevention      = 5
  require_lowercase_characters   = true
  require_uppercase_characters   = true
  require_numbers                = true
  require_symbols                = true
}
