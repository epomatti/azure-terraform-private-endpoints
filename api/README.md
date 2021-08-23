# Showcase API

## Local development

Install Mongo DB

```bash
docker pull mongo
docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=root mongo
```

Starting the app

```bash
# Dependencies
pipenv install
pipenv shell

# App
cp ./resources/development/development.env ./.env
export FLASK_ENV=development
export FLASK_APP=./src/app
python3 -m flask run
```

Also install `autopep8`.