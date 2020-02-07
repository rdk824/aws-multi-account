# ---------------------------------------------------------------------------
# Common
# ---------------------------------------------------------------------------

variable "namespace" {
  description = "Namespace used to create the organization remote state"
  default     = "organization"
}
variable "account_name" {
  description = "The account name"
  default     = "root"
}
variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}
