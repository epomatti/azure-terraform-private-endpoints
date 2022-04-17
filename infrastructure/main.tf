terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.2.0"
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
  name                = "vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags

}

resource "azurerm_subnet" "default" {
  name                 = "Subnet-001"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.10.0/24"]

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
    name                       = "DenyAllInbound"
    description                = ""
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllOutbound"
    description                = ""
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags

}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

# DNS

resource "azurerm_private_dns_zone" "cosmos" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos" {
  name                  = "cosmoslink"
  resource_group_name   = azurerm_resource_group.default.name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos.name
  virtual_network_id    = azurerm_virtual_network.default.id
  registration_enabled  = true
}

# Database

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "default" {
  name                 = "cosmos${random_integer.ri.result}"
  location             = azurerm_resource_group.default.location
  resource_group_name  = azurerm_resource_group.default.name
  offer_type           = "Standard"
  kind                 = "MongoDB"
  mongo_server_version = "4.0"

  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = true
  network_acl_bypass_ids            = []

  enable_free_tier = var.cosmos_enable_free_tier

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
    id = azurerm_subnet.default.id
  }

  backup {
    type = "Continuous"
  }

  tags = local.tags

}

resource "azurerm_cosmosdb_mongo_database" "default" {
  name                = "database"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
}

resource "azurerm_cosmosdb_mongo_collection" "employees" {
  name                = "employees"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
  database_name       = azurerm_cosmosdb_mongo_database.default.name

  shard_key = "name"

  index {
    keys = [
      "_id"
    ]

    unique = true
  }

}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "pe-cosmos"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = azurerm_subnet.default.id

  private_dns_zone_group {
    name = azurerm_private_dns_zone.cosmos.name
    private_dns_zone_ids = [
      azurerm_private_dns_zone.cosmos.id
    ]
  }

  private_service_connection {
    name                           = "cosmos"
    private_connection_resource_id = azurerm_cosmosdb_account.default.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

}


# App Service

resource "azurerm_service_plan" "default" {
  name                = "plan-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  os_type             = "Linux"
  sku_name            = var.appservice_sku_name
  tags                = local.tags
}

resource "azurerm_linux_web_app" "default" {
  name                = "app${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  service_plan_id     = azurerm_service_plan.default.id

  site_config {
    always_on = true

    application_stack {
      docker_image     = "epomatti/big-azure-terraform-showcase"
      docker_image_tag = "latest"
    }
  }

  app_settings = {
    DOCKER_ENABLE_CI                   = true
    #DOCKER_REGISTRY_SERVER_URL         = "https://ghcr.io"
    COSMOS_PRIMARY_CONNECTION_STRING   = azurerm_cosmosdb_account.default.connection_strings[0]
    COSMOS_SECONDARY_CONNECTION_STRING = azurerm_cosmosdb_account.default.connection_strings[1]
  }

  tags = local.tags

}
