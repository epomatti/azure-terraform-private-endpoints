variable "resource_group_name" {
  description = "Value of the resource group name"
  type        = string
  default     = "rg-showcase"
}

variable "resource_group_location" {
  description = "Value of the resource group location"
  type        = string
  default     = "eastus2"
}

variable "cosmos_enable_free_tier" {
  description = "Enable Free Tier for Cosmos DB"
  type        = bool
  default     = true
}

variable "appservice_sku_name" {
  description = "Tier for the App Service Plan"
  type        = string
  default     = "P1v3"
}

variable "appservice_docker_image" {
  description = "Docker image name"
  type        = string
  default     = "epomatti/big-azure-terraform-showcase"
}

variable "appservice_docker_image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "appservice_docker_registry_server_url" {
  description = "The URL of the docker registry"
  type        = string
  default     = "https://index.docker.io"
}
