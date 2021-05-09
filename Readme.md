### Simple Assembly Lane WebApp developed in Flask

#### This is a simple web application using Python Flask. The WebApp is used to demostrate building a Docker image.

```
Features of assembly-webapp:

   - Integrates Docker Hub and GitHub
   - Integrates Harbor Registry and GitLab
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

## Store secrets by using the pass insert command:

    \> pass insert HARBOR_USERNAME
    \> pass insert HARBOR_PASSWORD
    \> pass insert HARBOR_REGISTRY


### Set your environment - Read secrets from pass and set them as environment variables

    export HARBOR_USERNAME=$(pass HARBOR_USERNAME)
    export HARBOR_PASSWORD=$(pass HARBOR_PASSWORD)
    export HARBOR_REGISTRY=$(pass HARBOR_REGISTRY)