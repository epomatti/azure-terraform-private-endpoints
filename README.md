# Azure-Terraform Showcase

A showcase project demonstrating advanced Azure features using Terraform to build secure, reliable, scalable, and highly-available applications.

## To start the project

### Cloud Deployment
Open the [/infrasctructure](infrastructure) project and run the code with Terraform and everything must be setup automatically.

```bash
terraform init
terraform apply -auto-approve
```
The Python API is automatically deployed from the built packages in GHCR that you can find [here](https://github.com/epomatti/big-azure-terraform-showcase/pkgs/container/big-azure-terraform-showcase).

### Local Deployment

To run the project locally simply enter [/python api](/api) project and use Docker.

```bash
docker-compose up -d
```

## Infrastructure


Infra-as-code resources for the Showcase project.

### Provisioning

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


## Architecture

![Architecture](docs/media/diagram.png "Architecture")

The following capabilities are implemented:

- [x] Virtual Network Inbound / Outbound protection (NSG)
- [x] Cosmos DB Network Restrictions
- [x] Cosmos DB Private Endpoints + Standard Private DNS Zone
- [ ] Key Vault
- [ ] App Services
- [ ] Front Door
- [ ] WAF
- [ ] Bastion
- [ ] Kubernetes
