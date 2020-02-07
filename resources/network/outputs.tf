####################################################
# VPC
####################################################
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block of the VPC"
}


output "private_app_az_subnet_ids" {
  value = module.private_app_subnets.private_subnet_network_ids
}
output "private_data_az_subnet_ids" {
  value = module.private_data_subnets.private_subnet_network_ids
}

output "public_subnet_network_ids" {
  value = module.public_subnets.public_subnet_network_ids
}
