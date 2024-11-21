variable "environment" {
  description = "Environment Variable"
  type        = string
  default     = "PROD"
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

variable "resource_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet1"
}