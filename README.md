# Azure-Terraform Showcase

A showcase project demonstrating advanced Azure features using Terraform to build secure, reliable, scalable, and highly-available applications.

## Running it

Log into Azure with your favorite tool:

```sh
az login
```

Deploy the resources:

```sh
cd ./infrastructure

terraform init
terraform plan
terraform apply -auto-approve
```

This will take a long time.

## Local development

Begin by entering the API module:

```sh
cd ./api
```

### Mongo DB

```bash
docker pull mongo

docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME="app" \
  -e MONGO_INITDB_ROOT_PASSWORD="p4ssw0rd" mongo
```

### Python API

Setup the `.env` file environment variables:

```bash
cp resources/development.env .env
```

Start the app

```bash
# Dependencies
pipenv shell
pipenv install

# App
export FLASK_ENV=development
export FLASK_APP=src/app

python3 -m flask run
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