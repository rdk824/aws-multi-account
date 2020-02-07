#-- Common
variable "stage" {
  description = "Stage"
  default     = "prod"
}

variable "namespace" {
  description = "The namespace of the resource group."
  default     = "security"
}

#=============================================================
# KMS key
#=============================================================
variable "create_kms_key" {
  description = "Whether or not to create a KMS key"
  default     = false
}

variable "kms_key_alias" {
  default = "string"
  description = "KMS CMK label id"
}
