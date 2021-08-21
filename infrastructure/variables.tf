variable "resource_group_name" {
  description = "Value of the resource group name"
  type        = string
  default     = "rg-showcase"
}

variable "resource_group_location" {
  description = "Value of the resource group location"
  type        = string
  default     = "eastus"
}

variable "cosmos_enable_free_tier" {
  description = "Enable Free Tier for Cosmos DB"
  type        = bool
  default     = true
}

variable "appservice_tier" {
  description = "Tier for the App Service Plan"
  type        = string
  default     = "Standard"
}

variable "appservice_size" {
  description = "SKU for the App Service Plan"
  type        = string
  default     = "S1"
}
