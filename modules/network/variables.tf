#-- Common
variable "enable_label" {
  description = "Wheher or not to create a module label"
  default     = true
}
variable "stage" {
  description = "Stage"
  default     = "prod"
}

variable "namespace" {
  description = "The networking module namespace."
  default     = "network"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "region" {
  description = "The AWS region in which global resources are set up."
  default     = "ca-central-1"
}

variable "create_public_subnet" {
  description = "Set to true to prevent the module from creating a public subnet"
  default     = false
}

variable "create_private_db_subnet" {
  description = "Set to true to prevent the module from creating a private database subnet"
  default     = false
}

variable "create_private_app_subnet" {
  description = "Set to true to prevent the module from creating a purivate applications subnet"
  default     = false
}

variable "create_nat_gateway" {
  description = "Set to false to prevent the module from creating a nat gateway"
  default     = true
}

variable "availability_zones" {
  type        = "list"
  default     = []
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}


# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------

variable "cidr_block" {
  description = "The vpc CIDR block."
}

# ---------------------------------------------------------------------------
# VPC Flow Logs
# ---------------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of VPC"
  type        = "string"
  default     = ""
}

variable "flow_logs_label_id" {
  description = "VPC Flow logs Label"
  type        = "string"
  default     = ""
}

variable "cwl_log_group_name" {
  description = "CloudWatch Log group name"
  type        = "string"
  default     = ""
}

variable "cwl_label_id" {
  description = "CloudWatch Label ID"
    type        = "string"
    default     = ""
}

variable "cwl_label_tags" {
  description = "CloudWatch Label tags"
    type        = "map"
    default     = {}
}
