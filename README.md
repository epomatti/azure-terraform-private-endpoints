# Azure-Terraform Showcase

A showcase project demonstrating advanced Azure features using Terraform to build secure, reliable, and scalable applications.

![Architecture](docs/media/diagram.png "Architecture")

## Roadmap

- [x] Virtual Network Inbound / Outbound protection (NSG)
- [x] Cosmos DB Network Restrictions
- [x] Cosmos DB Private Endpoints + Standard Private DNS Zone
- [ ] App Services
- [ ] Front Door
- [ ] WAF
- [ ] Bastion
- [ ] More to come


## Infrastructure

Authenticate [locally to Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) and use the [Terraform CLI ](https://www.terraform.io/docs/cli/install/apt.html) for local testing.

```sh
# Create resources for testing
terraform init
terraform plan
terraform apply

# Destroy the test resources
terraform destroy
```
