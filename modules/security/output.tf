output "kms_arn" {
  value = module.kms_key.kms_arn
}

output "kms_key_id" {
  value = module.kms_key.kms_key_id
}
