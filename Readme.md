### Simple Assembly Lane WebApp developed in Flask

#### This is a simple web application using Python Flask. The WebApp is used to demostrate building a Docker image.

```
Features of assembly-webapp:

   - Integrates Docker Hub and GitHub
   - Provides colorful backgrounds
```

```
Below are the steps required to get this working on a base linux system.

    1. Install all required dependencies

        yum -y install python3 python3-pip

    2. Install and Configure Web Server

        pip3 install flask

    3. Start Web Server

        FLASK_APP=app.py flask run --host=localhost --port=8080

```