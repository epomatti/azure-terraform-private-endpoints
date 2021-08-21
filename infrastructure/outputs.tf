output "cosmos_name" {
  description = "Cosmos DB name dynamically generate."
  value       = azurerm_cosmosdb_account.default.name
}

output "cosmos_private_endpoint" {
  description = "Cosmos DB fully qualified domain (FQDN)"
  value       = azurerm_private_endpoint.cosmos.custom_dns_configs[0].fqdn
}
