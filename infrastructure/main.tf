terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
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

resource "azurerm_resource_group" "default" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = local.tags

}

resource "azurerm_virtual_network" "default" {
  name                = "vnet1"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "default" {
  name                 = "appservice-subnet1"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/hostingEnvironments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

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

  network_acl_bypass_ids = []

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

  tags = local.tags

}

# resource "azurerm_key_vault" "default" {
#   name                        = "examplekeyvault"
#   location                    = azurerm_resource_group.default.location
#   resource_group_name         = azurerm_resource_group.default.name
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   soft_delete_retention_days  = 7
#   purge_protection_enabled    = false

#   sku_name = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     secret_permissions = [
#       "Get",
#     ]
#   }
# }

resource "azurerm_app_service_plan" "default" {
  name                = "plan-${random_integer.ri.result}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = local.tags

}

resource "azurerm_app_service" "default" {
  name                = "app-${random_integer.ri.result}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.default.id

  site_config {
    scm_type = "LocalGit"
  }

  app_settings = {
    "COSMOS_KEY_TO_USE"                  = "primary"
    "COSMOS_PRIMARY_CONNECTION_STRING"   = azurerm_cosmosdb_account.default.connection_strings[0]
    "COSMOS_SECONDARY_CONNECTION_STRING" = azurerm_cosmosdb_account.default.connection_strings[1]
  }

  tags = local.tags

}
