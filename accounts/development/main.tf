
#========================================================
### Getting the current running account id
#========================================================
data "aws_caller_identity" "current" {}


#========================================================
### Getting the current running account id
#========================================================
module "network" {
  source                            = "../../modules/network"

  stage                             = "dev"
  availability_zones                = ["${var.aws_default_region}a", "${var.aws_default_region}b", "${var.aws_default_region}c"]
  #-- VPC
  cidr_block                        = "10.32.0.0/16"
  #-- Public subnet
  create_public_subnet              = true
  create_nat_gateway                = true
  #-- Private subnet
  create_private_db_subnet          = true
  create_private_app_subnet         = true
}
