# Additional Tools
&nbsp;
## Docker
&nbsp;
### Install
Download and install Docker from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop).

Open the application - it may prompt for password entry as it requires elevated permissions, if so enter password and run.

To check everything is running as it should, enter:

```bash
docker-compose --version
```

If this returns a valid version and build, you are good to go. 

&nbsp;
### Add Dockerfile
A Dockerfile is simply a list of instructions for Docker to create our project image.

Create a new file in the root of the project and call it `Dockerfile` with no extension. First step is to search Docker for the version of the language we are going to use - in this case Python 3.7 - and to link it to our Dockerfile. Clicking on the respective image (we used `3.7-alpine` which is a lightweight Docker version) version takes us to GitHub.

Inside the file include the following code:

```docker
# Import the respective image, format should be `<language>:<tag>` 
FROM python:3.7-alpine

# is not necessary but keeps a record of who the owner and official maintainer of the project is
MAINTAINER pj1301

# Tells Python to run in unbuffered mode which is a recommended setting for Python when running inside Docker containers
ENV PYTHONUNBUFFERED 1

# Tell Docker to copy the requirements from the adjactent file ./requirements.txt into a file on the Docker image of the same name
COPY ./requirements.txt /requirements.txt

# Install the requirements from the newly created file on the Docker image onto the Docker image
RUN pip install -r /requirements.txt

# Create an empty folder on our Docker image
RUN mkdir /app

# Switch the default directory to this new directory on our Docker image (the application will then run from this as the root, unless we specify otherwise later)
WORKDIR /app

# Copy code from our app folder into the default directory now on our Docker image; Assumes that app is the working directory inside the development folder, if the directory doesn't match an error will be presented
COPY ./app /app

# BELOW IS A SECURITY MEASURE - TO PREVENT ROOT ACCESS TO THE DOCKER IMAGE IF THE APPLICATION IS HACKED
# Create a user, '-D' indicates that this user should only be used to run our project
RUN adduser -D user
# Switches Docker to the newly created user thereby limiting the accessible scope inside our Docker container
USER user
```

&nbsp;
### Requirements
The requirements.txt file contains all of the dependencies for our project. In a sense, it's kind of like our package.json file in JS.

To add a dependency, type the name and then specify the version or range of versions as so:

```txt
# Installs latest version before 2.2.0, essentially the latest minor version (no breaking changes)
Django>=2.1.3,<2.2.0
```

&nbsp;
### Build
To build a Docker project, simply enter in the terminal:

```bash
docker build .
```

&nbsp;
### Compose
Docker compose is a tool which allows us to run our Docker image from the project directory and carry out any other service commands as well. It requires a config file in order to run, so let's create `docker-compose.yml` in the root directory and enter the following content:


```yml
# Version of Docker Compose
version: "3"

# list services
services: 
  app: # we will have a service called app
    build:
      context: . # sets the current directory
    ports: # map port from the coded application to a port on the Docker image - in this case it's the same
      - "8000:8000"
    volumes: # maps a volume from our development drive onto the Docker image in the default directory
      - ./app:/app
    command: > # basically like scripts from package.json; '>' allows escape onto the next line, ensure the indent is preserved
      sh -c "python manage.py runserver 0.0.0.0:8000" 

```
The command line above is essentially a shell script, `-c` is for command, then the command follows in quotation marks. Note, the server is the actual development server which will be mapped onto the Docker drive. So it could be 2000 and then the ports line would look like this:

```yml
...
ports:
  - "2000:8000"
...
command: sh -c "python manage.py runserver 0.0.0.0:2000"
```

To compose, run the following in the terminal:

```bash
docker-compose build
```

Finally to create our project using the Django manager (like a Django CLI), run:

```bash
docker-compose run app sh -c "django-admin.py startproject app ."
```
It's all boilerplate except for the `app` and `.` parts. `app` is our development directory, `.` indicates that the build should be in the default folder inside the Docker image (which we specified as `app` also.).

Once this has run, open the app folder in the development root and you will see the Docker app folder with all of the required Django Python files included inside.


&nbsp;
### Notes

`ENV` is how you set environment variables in Docker. The variable name should always be in CAPITALS.

&nbsp;
## Travis CI

&nbsp;
### Activate Project
Go to travis-ci.org and sign in using your GitHub account. Once activated, click the + on the right hand side of the page to select one of your repos to be activated. Find the repository you created for this project (it must be public), then click activate repository.

&nbsp;
### Configure Travis CI
The travis configuration file tells Travis what to do every time we push a change to the activated repository. Create `.travis.yml` in the root directory and add the following:

```yml
# Specify the language
language: python
python:
  # specify the version of the language
    - "3.6"

# Specify the services
services:
  - docker

# Before the script is run, do this
before_script: pip install docker-compose

# Then run the script - note that flake8 is our linter that hasn't been configured yet
# If this fails, the build will fail and an error will be returned
script: 
  - docker-compose run app sh -c "python manage.py test && flake8"
```


&nbsp;
## PostgreSQL


&nbsp;
## Flake8
First add Flake8 to the requirements file:

```txt
...
flake8>=3.6.0,<3.7.0
```

### Config
The config file for the Flake8 linter should be added inside our docker directory.

./app/app/.flake8
```

```