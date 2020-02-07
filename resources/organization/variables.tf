variable "aws_region" {
  type = "string"
}

variable "aws_org_account_ids" {
  type = "map"
}

variable "create_prod_cross_account_roles" {
  description = "Create IAM roles for the Accounts"
  default     = true
}

variable "create_group" {
description = "Set to true if you want to create a group"
  default     = false
}

variable "create_staging_cross_account_roles" {
  description = "Create IAM roles for the Accounts"
  default     = true
}

variable "create_dev_cross_account_roles" {
  description = "Create IAM roles for the Accounts"
  default     = true
}

variable "create_prod_password_policy" {
  description = "Whether or not to create the IAM account password policy"
  default     = true
}

variable "create_staging_password_policy" {
  description = "Whether or not to create the IAM account password policy"
  default     = true
}

variable "create_dev_password_policy" {
  description = "Whether or not to create the IAM account password policy"
  default     = true
}

variable "create_root_password_policy" {
  description = "Whether or not to create the IAM account password policy"
  default     = true
}
