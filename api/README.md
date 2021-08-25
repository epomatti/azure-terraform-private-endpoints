# Showcase API

## Local development

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
pipenv install --dev
pipenv shell

# App
export FLASK_ENV=development
export FLASK_APP=src/app
python3 -m flask run

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