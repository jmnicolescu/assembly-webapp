### Technical DEMO - The cloud native journey
```
    1. Create a traditional, simple Web App using Python and Flask.

    2. Run the monolithic Web App 

    3. Containerize the Web App 
            Create the Docker File
            Package the Web App into a Docker image

    4. Run the container from an image using the docker run command. 
            Will run the container on the local host.

    5. Build new Docker images using GitLab CI/CD and push the images to Harbor Registry
            CI/CD is a critical piece of the puzzle because it enables an automated processes for creating new images.
            This is an  example of building a Pipeline based on GitLab and Harbor 
            We will create application code version 1.0, push the cod to GitLab, run the CI/CD Pipeline, create a new Docker Image, push the image to Harbor and tag the image using the version 1.0 tag.
            We will update the application code to version 2.0, push the cod to GitLab, run the CI/CD Pipeline, create a new Docker Image, push the new image to Harbor and tag the image using the version 2.0 tag.

        6. Build new images using GitHub and Docker Hub
            We will build Docker Images automatically when a new version of the code is push to GitHub
            Docker role in Ci/CD pipeline

        7. Deploy the Web App to Kubernetes
            We will create a Namespace, a Kubernetes Deployment File and will expose Web App service to the outside world.
            We will look at two deployment options. One deployment will create a Service of Type LoadBalancer. The second deployment will use the Ingress Controller.

        8. Upgrade the Web App to a new version 
            We will upgrade the Web App to a new version by building and deploying a newer Docker image.
            Kubernetes rolling update feature lets us update the Deployments without downtime.
            During a rolling update, the cluster incrementally replaces the existing web app Pods with Pods containing the Docker image for the new version. 

        9. Scale the Web App when the demand increases 
            We will upgrade the web-app to a new version by building and deploying a newer Docker image.
            Kubernetes rolling update feature lets us update the Deployments without downtime.
            During a rolling update, the cluster incrementally replaces the existing web app Pods with Pods containing the Docker image for the new version. 
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