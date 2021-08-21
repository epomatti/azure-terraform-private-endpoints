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
  name                = "vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags

  # lifecycle {
  #   ignore_changes = [
  #     subnet
  #   ]
  # }

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

  # lifecycle {
  #   ignore_changes = [
  #     service_endpoint_policy_ids
  #   ]
  # }

}

resource "azurerm_network_security_group" "default" {
  name                = "ngs"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "Deny All Inbound"
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
    name                       = "Deny All Outbound"
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

  tags = local.tags

}

resource "azurerm_cosmosdb_mongo_database" "default" {
  name                = "database"
  resource_group_name = azurerm_cosmosdb_account.default.resource_group_name
  account_name        = azurerm_cosmosdb_account.default.name
}

resource "azurerm_private_endpoint" "cosmos" {
  name                = "pe-cosmos"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  subnet_id           = azurerm_subnet.default.id

  private_service_connection {
    name                           = "cosmos"
    private_connection_resource_id = azurerm_cosmosdb_account.default.id
    is_manual_connection           = false
    subresource_names              = ["MongoDB"]
  }

  tags = local.tags

}

# App Service

# resource "azurerm_app_service_plan" "default" {
#   name                = "plan-${random_integer.ri.result}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name

#   sku {
#     tier = var.appservice_tier
#     size = var.appservice_size
#   }

#   tags = local.tags

# }

# resource "azurerm_app_service" "default" {
#   name                = "app${random_integer.ri.result}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
#   app_service_plan_id = azurerm_app_service_plan.default.id

#   site_config {
#     scm_type      = "LocalGit"
#     always_on     = true
#     http2_enabled = true
#     #cors
#   }

#   app_settings = {
#     "COSMOS_PRIVATE_ENDPOINT"            = azurerm_private_endpoint.cosmos.custom_dns_configs[0].fqdn
#     "COSMOS_KEY_TO_USE"                  = "primary"
#     "COSMOS_PRIMARY_CONNECTION_STRING"   = azurerm_cosmosdb_account.default.connection_strings[0]
#     "COSMOS_SECONDARY_CONNECTION_STRING" = azurerm_cosmosdb_account.default.connection_strings[1]
#   }

#   tags = local.tags

# }

# resource "azurerm_frontdoor" "example" {
#   name                                         = "app${random_integer.ri.result}"
#   resource_group_name                          = azurerm_resource_group.default.name
#   enforce_backend_pools_certificate_name_check = false

#   frontend_endpoint {
#     name      = random_integer.ri.result
#     host_name = "${random_integer.ri.result}.azurefd.net"

#   }

#   backend_pool_load_balancing {
#     name = "exampleLoadBalancingSettings1"
#   }

#   backend_pool_health_probe {
#     name = "exampleHealthProbeSetting1"
#   }

#   backend_pool {
#     name = "exampleBackendBing"
#     backend {
#       host_header = "www.bing.com"
#       address     = "www.bing.com"
#       http_port   = 80
#       https_port  = 443
#     }

#     load_balancing_name = "exampleLoadBalancingSettings1"
#     health_probe_name   = "exampleHealthProbeSetting1"
#   }

#   routing_rule {
#     name               = "http_redirect"
#     accepted_protocols = ["http"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = ["exampleFrontendEndpoint1"]
#     forwarding_configuration {
#       forwarding_protocol = "MatchRequest"
#       backend_pool_name   = "exampleBackendBing"
#     }
#   }

#   routing_rule {
#     name               = "exampleRoutingRule1"
#     accepted_protocols = ["Http", "Https"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = ["exampleFrontendEndpoint1"]
#     forwarding_configuration {
#       forwarding_protocol = "MatchRequest"
#       backend_pool_name   = "exampleBackendBing"
#     }
#   }




# }

#######
# https://docs.microsoft.com/en-us/azure/private-link/tutorial-private-endpoint-cosmosdb-portal?bc=/azure/cosmos-db/breadcrumb/toc.json&toc=/azure/cosmos-db/toc.json
