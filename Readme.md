### Simple Assembly Lane WebApp developed in Flask

#### This is a simple web application using Python Flask. The WebApp is used to demostrate building a Docker image.

```
Features of assembly-webapp:

   - Integrates Docker Hub and GitHub
   - Integrates Harbor Registry and GitLab

```

```
How to run this demo: Run make with one of the following options:

   - [make run-local] - run assembly-webapp, a Flask based app, on the local system
   - [make docker-image] - build assembly-webapp docker image
   - [make run-docker-image] - run 3 containers using assembly-webapp docker image
   - [make docker-clean] - stop assembly-webapp containers and remove assembly-webapp docker images

   - [make build-version1] - push code version 1.0 to gitlab, run CI/CD Pipeline, push image to Docker Hub
   - [make build-version2] - push code version 2.0 to gitlab, run CI/CD Pipeline, push image to Docker Hub
   - [make harbor-version1] - build docker image version 1.0, push image to Docker Hub
   - [make harbor-version2] - build docker image version 2.0, push image to Docker Hub

   ----- Deployment using Service type LoadBalance -----
   - [make kubernetes-deploy-webapp] - deploy assembly-webapp to Kubernetes using the latest Harbor image
   - [make kubernetes-delete-webapp] - delete assembly-webapp deployment and namespace
   - [make kubernetes-update-webapp-version1] - update assembly-webapp pod images to version 1.0
   - [make kubernetes-update-webapp-version2] - update assembly-webapp pod images to version 2.0
   - [make kubernetes-update-webapp-replicas-3] - scale assembly-webapp to 3 pods
   - [make kubernetes-update-webapp-replicas-6] - scale assembly-webapp to 6 pods

   ----- Deployment using Ingress Controller -----
   - [make deploy-assembly-ingress] - deploy assembly-webapp to Kubernetes using the latest Harbor image
   - [make delete-assembly-ingress] - delete assembly-webapp deployment and namespace
   - [make update-assembly-ingress-version1] - update assembly-webapp pod images to version 1.0
   - [make update-assembly-ingress-version2] - update assembly-webapp pod images to version 2.0
   - [make update-assembly-ingress-replicas-3] - scale assembly-webapp to 3 pods
   - [make update-assembly-ingress-replicas-6] - scale assembly-webapp to 6 pods

```


## Store secrets by using the pass insert command:

    \> pass insert HARBOR_USERNAME
    \> pass insert HARBOR_PASSWORD
    \> pass insert HARBOR_REGISTRY


### Set your environment - Read secrets from pass and set them as environment variables

    export HARBOR_USERNAME=$(pass HARBOR_USERNAME)
    export HARBOR_PASSWORD=$(pass HARBOR_PASSWORD)
    export HARBOR_REGISTRY=$(pass HARBOR_REGISTRY)