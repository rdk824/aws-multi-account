# create a s3 endpoint that open to app's routing table
data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = module.vpc.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}
