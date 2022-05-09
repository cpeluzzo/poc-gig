variable "tag" {
  type    = string
}

variable "basename" {
  type        = string
  description = "(Mandatory) - Basename of the resources"
}

variable "location" {
  type        = string
  description = "(Mandatory) - Location of the resouces"
}

variable "kv_name" {
  type        = string
  description = "(Mandatory) - Name of KeyVault"
}

variable "kv_rg" {
  type        = string
  description = "(Mandatory) - Resource group kv"
}

variable "uservm" {
  type        = string
  description = "(Mandatory) - User of vm"
}
