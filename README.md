# Azure-Terraform Showcase

A showcase project demonstrating advanced Azure features using Terraform to build secure, reliable, scalable, and highly-available applications.


## Infrastructure

Log into Azure with your favorite tool:

```sh
az login
```

Deploy the resources:

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

## Local development

Make sure you're using the appropriate python version: `3.9`

Install Mongo DB

```bash
docker pull mongo
docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME="<USERNAME>" -e MONGO_INITDB_ROOT_PASSWORD="<PASSWORD>" mongo
```

Setup the `.env` file environment varialbes

```bash
cp resources/development/development.env .env
```

Start the app

```bash
# Dependencies
pipenv install --python 3.9 --dev
pipenv shell

# App
export FLASK_ENV=development
export FLASK_APP=src/app
python3.9 -m flask run

# Development tools
pipenv install autopep8 --dev
```


## Testing with Docker locally

Pull MongoDB

```bash
# pull pongo
docker pull mongo

#build the app
docker build -t big-aztf-app .
```

Run docker compose

```bash
# start it
docker-compose up -d

# troubleshoot
docker-compose logs -f
```


## Roadmap


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

## Sources

```

```