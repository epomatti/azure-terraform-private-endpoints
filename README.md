# azure-secure-app

A secure app using Azure technologies.


## Roadmap

- [x] Private Network
- [x] Private Endpoints
- [x] Front Door
- [ ] WAF
- [ ] Private DNS Zone
- [ ] Bastion


## Infrastructure

Authenticate [locally to Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli) and use the [Terraform CLI ](https://www.terraform.io/docs/cli/install/apt.html) for local testing.

```sh
cd ./test

# Create resources for testing
terraform init
terraform plan
terraform apply

# Destroy the test resources
terraform destroy
```
