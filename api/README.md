
FLASK_APP

pipenv install
pipenv shell

python -m flask

https://flask.palletsprojects.com/en/2.0.x/quickstart/#a-minimal-application

export FLASK_ENV=development
export FLASK_APP=./src/app
python -m flask run

## Mongo

docker pull mongo
docker run --name some-mongo -d mongo:tag

```
docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=root mongo
```