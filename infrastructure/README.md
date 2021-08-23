# Infrastructure

Infra-as-code resources for the Showcase project.

## Provisioning

Authenticate [locally to Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) and use the [Terraform CLI ](https://www.terraform.io/docs/cli/install/apt.html) for local testing.

```sh
# Create resources for testing
terraform init
terraform plan
terraform apply

# Destroy the test resources
terraform destroy
```

Sources: [Private Endpoint Cosmos](https://docs.microsoft.com/en-us/azure/private-link/tutorial-private-endpoint-cosmosdb-portal?bc=/azure/cosmos-db/breadcrumb/toc.json&toc=/azure/cosmos-db/toc.json), [Private Endpoint DNS](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns)
