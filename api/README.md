
FLASK_APP

pipenv install
pipenv shell

python -m flask

https://flask.palletsprojects.com/en/2.0.x/quickstart/#a-minimal-application

export FLASK_ENV=development
export FLASK_APP=./src/app
python -m flask run