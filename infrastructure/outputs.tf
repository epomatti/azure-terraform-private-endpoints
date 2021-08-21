output "cosmos_name" {
  description = "Cosmos DB name dynamically generate."
  value       = azurerm_cosmosdb_account.default.name
}