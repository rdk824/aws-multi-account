data "aws_caller_identity" "current" {
}

module "admin" {
  source                    = "git::https://github.com/rdansou/terraform-aws-modules.git//iam?ref=master"
  create_user               = true
  user_group_name           = module.admin_iam_groups.group_id
  users                     = [
                                {
                                  user_name     = "admin"
                                  path          = "/"
                                  force_destroy = "false"
                                },
                              ]
}

module "root_secure_baseline" {
  source = "nozaq/secure_baseline"

  account_type                         = "master"
  audit_log_bucket_name                = var.audit_s3_bucket_name
  aws_account_id                       = data.aws_caller_identity.current.account_id
  region                               = var.region
  support_iam_role_principal_arn       = module.admin.user_arn[0]
  guardduty_disable_email_notification = true

  member_accounts                      = [
                                          lookup(var.aws_org_account_ids, "dev"),
                                          lookup(var.aws_org_account_ids, "prod")
                                        ]
                                        
  # Setting it to true means all audit logs are automatically deleted
  #   when you run `terraform destroy`.
  # Note that it might be inappropriate for highly secured environment.
  audit_log_bucket_force_destroy = false

  providers = {
    aws                = aws
    aws.ap-northeast-1 = aws.ap-northeast-1
    aws.ap-northeast-2 = aws.ap-northeast-2
    aws.ap-south-1     = aws.ap-south-1
    aws.ap-southeast-1 = aws.ap-southeast-1
    aws.ap-southeast-2 = aws.ap-southeast-2
    aws.ca-central-1   = aws.ca-central-1
    aws.eu-central-1   = aws.eu-central-1
    aws.eu-north-1     = aws.eu-north-1
    aws.eu-west-1      = aws.eu-west-1
    aws.eu-west-2      = aws.eu-west-2
    aws.eu-west-3      = aws.eu-west-3
    aws.sa-east-1      = aws.sa-east-1
    aws.us-east-1      = aws.us-east-1
    aws.us-east-2      = aws.us-east-2
    aws.us-west-1      = aws.us-west-1
    aws.us-west-2      = aws.us-west-2
  }
}
