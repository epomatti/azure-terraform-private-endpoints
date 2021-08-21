terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.73.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    "app" = "secureapp"
  }
}

# Group

resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = local.tags

}

# Networking

resource "azurerm_virtual_network" "default" {
  name                = "vnet1"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "cosmos" {
  name                 = "appservice-subnet-cosmos"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.20.0/24"]

  enforce_private_link_endpoint_network_policies = true

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.Web"
  ]

}

resource "azurerm_network_security_group" "default" {
  name                = "ngs"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags

}

resource "azurerm_subnet_network_security_group_association" "cosmos" {
  subnet_id                 = azurerm_subnet.cosmos.id
  network_security_group_id = azurerm_network_security_group.default.id
}

# Database

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "default" {
  name                = "cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = true
  network_acl_bypass_ids            = []

  capabilities {
    name = "EnableMongo"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.default.location
    failover_priority = 0
  }

  virtual_network_rule {
    id = azurerm_subnet.cosmos.id
  }

  tags = local.tags

}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "pe-cosmos-${random_integer.ri.result}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = azurerm_subnet.cosmos.id

  private_service_connection {
    name                           = "cosmos-pe"
    private_connection_resource_id = azurerm_cosmosdb_account.default.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

  tags = local.tags

}

# resource "azurerm_app_service_plan" "default" {
#   name                = "plan-${random_integer.ri.result}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name

#   sku {
#     tier = "Standard"
#     size = "S1"
#   }

#   tags = local.tags

# }

# resource "azurerm_app_service" "default" {
#   name                = "app-${random_integer.ri.result}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
#   app_service_plan_id = azurerm_app_service_plan.default.id

#   site_config {
#     scm_type = "LocalGit"
#   }

#   app_settings = {
#     "COSMOS_KEY_TO_USE"                  = "primary"
#     "COSMOS_PRIMARY_CONNECTION_STRING"   = azurerm_cosmosdb_account.default.connection_strings[0]
#     "COSMOS_SECONDARY_CONNECTION_STRING" = azurerm_cosmosdb_account.default.connection_strings[1]
#   }

#   tags = local.tags

# }
