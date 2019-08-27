
#===============================================================================#
# Organization Members Account Groups
#===============================================================================#

#-------------------------------------------
### Organization Admin Account Groups
#--------------------------------------------
module "admin_iam_groups" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_group              = var.create_group
  group_name                = "Admin"
  group_policy              = module.admin_policy.policy_arn
}
module "admin_policy" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_iam_policy         = var.create_group
  policy_name               = "AdminAccessPolicy"
  policy                    = data.aws_iam_policy_document.admin.json
}
module "admin_iam_common" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_policy_attachment  = var.create_group
  group_name                = module.admin_iam_groups.group_id
  group_policy              = module.common_policy.policy_arn
}

#-------------------------------------------
### Organization Dev Account Groups
#--------------------------------------------
module "dev_iam_groups" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_group              = var.create_group
  group_name                = "Dev"
  group_policy              = module.dev_policy.policy_arn
}
module "dev_policy" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_iam_policy         = var.create_group
  policy_name               = "DevAccessPolicy"
  policy                    = data.aws_iam_policy_document.dev.json
}
module "dev_iam_common" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_policy_attachment  = var.create_group
  group_name                = module.dev_iam_groups.group_id
  group_policy              = module.common_policy.policy_arn
}

#-------------------------------------------
### Organization ReadOnly Account Groups
#--------------------------------------------
module "read_only_iam_groups" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_group              = var.create_group
  group_name                = "ReadOnly"
  group_policy              = module.read_only_policy.policy_arn
}
module "read_only_policy" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_iam_policy         = var.create_group
  policy_name               = "ReadOnlyAccessPolicy"
  policy                    = data.aws_iam_policy_document.read_only.json
}
module "read_only_iam_common" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_policy_attachment  = var.create_group
  group_name                = module.read_only_iam_groups.group_id
  group_policy              = module.common_policy.policy_arn
}

#-------------------------------------------
### Common Policy
#--------------------------------------------
module "common_policy" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_iam_policy         = var.create_group
  policy_name               = "UserAccessPolicy"
  policy                    = data.aws_iam_policy_document.common.json
}

#===============================================================================#
# Group policies
#===============================================================================#
#-------------------------------------------
### Administrator Policy
#--------------------------------------------
data "aws_iam_policy_document" "admin" {
  source_json = file("${path.module}/iam-policy-files/admin_policy.json")
  statement {
    sid       = "AllowAdminCrossAccountAccess"
    actions   = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "prod")}:role/AdminAccessRole",
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "dev")}:role/AdminAccessRole",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

#-------------------------------------------
### Developer Policy
#--------------------------------------------
data "aws_iam_policy_document" "dev" {
  source_json = file("${path.module}/iam-policy-files/power_user_policy.json")
  statement {
    actions   = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "prod")}:role/ReadOnlyAccessRole",
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "dev")}:role/DevAccessRole"
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

#-------------------------------------------
### Read-Only Policy
#--------------------------------------------
data "aws_iam_policy_document" "read_only" {
  source_json = file("${path.module}/iam-policy-files/read_only_policy.json")
  statement {
    actions   = ["sts:AssumeRole"]

    resources = [
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "prod")}:role/ReadOnlyAccessRole",
      "arn:aws:iam::${lookup(var.aws_org_account_ids, "dev")}:role/ReadOnlyAccessRole"
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

#-------------------------------------------
### Common Policy
#--------------------------------------------
data "aws_iam_policy_document" "common" {
  statement {
    sid = "AllowUsersToCreateEnableResyncDeleteTheirOwnVirtualMFADevice"

    actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]
  }

  statement {
    sid = "AllowUsersToDeactivateTheirOwnVirtualMFADevice"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/&{aws:username}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}",
    ]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid = "AllowUsersToListMFADevicesandUsersForConsole"

    actions = [
      "iam:ListMFADevices",
      "iam:ListVirtualMFADevices",
      "iam:ListUsers",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions   = ["iam:ChangePassword"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/&{aws:username}"]
  }

  statement {
    actions   = ["iam:GetAccountPasswordPolicy"]
    resources = ["*"]
  }
}
