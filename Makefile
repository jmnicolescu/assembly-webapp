# -------------------------------------------------------------
# File Name: Makefile
# Sun May  9 12:29:54 BST 2021 - juliusn - initial script
# -------------------------------------------------------------
.PHONY: kubernetes-deploy-webapp kubernetes-delete-webapp update-webapp-version1
.PHONY: deploy-assembly-ingress delete-assembly-ingress update-assembly-ingress-version1 update-assembly-ingress-version2
.PHONY: update-assembly-ingress-replicas-3 update-assembly-ingress-replicas-6
.PHONY: kubernetes-update-webapp-version1 kubernetes-update-webapp-version2
.PHONY: kubernetes-update-webapp-replicas-3 kubernetes-update-webapp-replicas-6
.PHONY: run-local docker-image run-docker-image docker-clean build-version1 build-version2 harbor-version1 harbor-version2

build:
	@echo " "
	@echo "Run make with one of the following options: "
	@echo "  [make run-local] - run assembly-webapp, a Flask based app, on the local system."
	@echo "  [make docker-image] - build assembly-webapp docker image"
	@echo "  [make run-docker-image] - run 3 containers using assembly-webapp docker image"
	@echo "  [make docker-clean] - stop assembly-webapp containers and remove assembly-webapp docker images"
	@echo "  [make build-version1] - push code version 1.0 to gitlab, run CI/CD Pipeline, push image to Harbor Registry"
	@echo "  [make build-version2] - push code version 2.0 to gitlab, run CI/CD Pipeline, push image to Harbor Registry"
	@echo "  [make harbor-version1] - build docker image version 1.0, push image to Harbor Registry"
	@echo "  [make harbor-version2] - build docker image version 2.0, push image to Harbor Registry"
	
	@echo "  ----- Deployment using Service type LoadBalance -----"
	@echo "  [make kubernetes-deploy-webapp] - deploy assembly-webapp to Kubernetes using the latest Harbor image"
	@echo "  [make kubernetes-delete-webapp] - delete assembly-webapp deployment and namespace"
	@echo "  [make kubernetes-update-webapp-version1] - update assembly-webapp pod images to version 1.0"
	@echo "  [make kubernetes-update-webapp-version2] - update assembly-webapp pod images to version 2.0"
	@echo "  [make kubernetes-update-webapp-replicas-3] - scale assembly-webapp to 3 pods"
	@echo "  [make kubernetes-update-webapp-replicas-6] - scale assembly-webapp to 6 pods"

	@echo "  ----- Deployment using Ingress Controller -----"
	@echo "  [make deploy-assembly-ingress] - deploy assembly-webapp to Kubernetes using the latest Harbor image"
	@echo "  [make delete-assembly-ingress] - delete assembly-webapp deployment and namespace"
	@echo "  [make update-assembly-ingress-version1] - update assembly-webapp pod images to version 1.0"
	@echo "  [make update-assembly-ingress-version2] - update assembly-webapp pod images to version 2.0"
	@echo "  [make update-assembly-ingress-replicas-3] - scale assembly-webapp to 3 pods"
	@echo "  [make update-assembly-ingress-replicas-6] - scale assembly-webapp to 6 pods"
	@echo " "

clean: delete-assembly-ingress kubernetes-delete-webapp docker-clean

run-local:
	FLASK_APP=app.py flask run --host=localhost --port=8080

docker-image:
	docker build  . -t  jmnicolescu/assembly-webapp
	docker tag jmnicolescu/assembly-webapp:latest harbor.flexlab.local/jmnicolescu/assembly-webapp:latest

run-docker-image:
	docker run -p 8080:8080 -d jmnicolescu/assembly-webapp
	docker run -p 8081:8080 -d jmnicolescu/assembly-webapp
	docker run -p 8082:8080 -d jmnicolescu/assembly-webapp

docker-clean:
	docker ps | grep "FLASK" | awk '{print $$1}' | xargs --no-run-if-empty docker stop
	docker ps -a | grep "FLASK" | awk '{print $$1}' | xargs --no-run-if-empty docker rm
	docker images -a | grep "assembly-webapp" | awk '{print $$3}' | xargs --no-run-if-empty docker rmi --force

build-version1:
	sed -i 's/version="[0-9].0"/version="1.0"/g' Dockerfile
	cp templates/index_1.0.html templates/index.html
	git add .
	git commit -m "update to version 1.0"
	git push
	git tag 1.0
	git push --tags

build-version2:
	sed -i 's/version="[0-9].0"/version="2.0"/g' Dockerfile
	cp templates/index_2.0.html templates/index.html
	git add .
	git commit -m "update to version 2.0"
	git push -o ci.variable="BUILD_TAG_VERSION=2.0"

harbor-version1:
	@echo " "
	@echo "BUILDING ASSEMBLY-WEBAPP VERSION 1.0 "
	@echo "[assembly-webapp] Step 1: Update code"
	sed -i 's/version="[0-9].0"/version="1.0"/g' Dockerfile
	cp templates/index_1.0.html templates/index.html
	@echo " "
	@echo "[assembly-webapp] Step 2: Create Docker Image"
	docker build  . -t  jmnicolescu/assembly-webapp:1.0 -t jmnicolescu/assembly-webapp:latest
	docker tag jmnicolescu/assembly-webapp:1.0 harbor.flexlab.local/jmnicolescu/assembly-webapp:1.0
	docker tag jmnicolescu/assembly-webapp:latest harbor.flexlab.local/jmnicolescu/assembly-webapp:latest
	@echo " "
	@echo "[assembly-webapp] Step 3: Push image to registry"
	@echo "Login to ${HARBOR_REGISTRY}"
	@echo -n ${HARBOR_PASSWORD} | docker login -u ${HARBOR_USERNAME} --password-stdin https://${HARBOR_REGISTRY}
	docker push ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:1.0
	docker push ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:latest
	docker pull ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:1.0
	docker pull ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:latest
	@echo "Logout from ${HARBOR_REGISTRY}"
	@docker logout https://${HARBOR_REGISTRY}

harbor-version2:
	@echo " "
	@echo "BUILDING ASSEMBLY-WEBAPP VERSION 2.0 "
	@echo "[assembly-webapp] Step 1: Update code"
	sed -i 's/version="[0-9].0"/version="2.0"/g' Dockerfile
	cp templates/index_2.0.html templates/index.html
	@echo " "
	@echo "[assembly-webapp] Step 2: Create Docker Image"
	docker build  . -t  jmnicolescu/assembly-webapp:2.0 -t jmnicolescu/assembly-webapp:latest
	docker tag jmnicolescu/assembly-webapp:2.0 harbor.flexlab.local/jmnicolescu/assembly-webapp:2.0
	docker tag jmnicolescu/assembly-webapp:latest harbor.flexlab.local/jmnicolescu/assembly-webapp:latest
	@echo " "
	@echo "[assembly-webapp] Step 3: Push image to registry"
	@echo "Login to ${HARBOR_REGISTRY}"
	@echo -n ${HARBOR_PASSWORD} | docker login -u ${HARBOR_USERNAME} --password-stdin https://${HARBOR_REGISTRY}
	docker push ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:2.0
	docker push ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:latest
	docker pull ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:2.0
	docker pull ${HARBOR_REGISTRY}/jmnicolescu/assembly-webapp:latest
	@echo "Logout from ${HARBOR_REGISTRY}"
	@docker logout https://${HARBOR_REGISTRY}

kubernetes-deploy-webapp:
	kubectl apply -f deploy-assembly-lb/namespace-definition.yaml
	kubectl apply -f deploy-assembly-lb/deployment-definition.yaml
	kubectl get pods --namespace=assembly
	kubectl get pods --namespace assembly -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort
	kubectl get services --namespace=assembly

kubernetes-delete-webapp:
	kubectl delete --all  deployments,services,replicasets --namespace=assembly
	kubectl delete namespace assembly

kubernetes-update-webapp-version1:
	kubectl -n assembly set image deployment.apps/assembly-deployment assembly-webapp=harbor.flexlab.local/jmnicolescu/assembly-webapp:1.0
	kubectl -n assembly rollout status deployment.apps/assembly-deployment
	kubectl get pods --namespace=assembly
	kubectl get pods --namespace assembly -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

kubernetes-update-webapp-version2:
	kubectl -n assembly set image deployment.apps/assembly-deployment assembly-webapp=harbor.flexlab.local/jmnicolescu/assembly-webapp:2.0
	kubectl -n assembly rollout status deployment.apps/assembly-deployment
	kubectl get pods --namespace=assembly
	kubectl get pods --namespace assembly -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

kubernetes-update-webapp-replicas-3:
	kubectl scale deployment.apps/assembly-deployment --replicas=3 --namespace=assembly
	kubectl get pods --namespace=assembly
	kubectl get pods --namespace assembly -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

kubernetes-update-webapp-replicas-6:
	kubectl scale deployment.apps/assembly-deployment --replicas=6 --namespace=assembly
	kubectl get pods --namespace=assembly
	kubectl get pods --namespace assembly -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

deploy-assembly-ingress:
	kubectl apply -f deploy-assembly-ingress/namespace-definition.yaml
	rm -f deploy-assembly-ingress/assembly-webapp-tls.key deploy-assembly-ingress/assembly-webapp-tls.crt
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout deploy-assembly-ingress/assembly-webapp-tls.key -out deploy-assembly-ingress/assembly-webapp-tls.crt -subj "/CN=assembly-webapp.flexlab.local/O=assembly-webapp"
	kubectl create secret tls assembly-webapp-tls --key deploy-assembly-ingress/assembly-webapp-tls.key --cert deploy-assembly-ingress/assembly-webapp-tls.crt -n assembly-ingress
	kubectl apply -f deploy-assembly-ingress/deployment-definition.yaml
	kubectl get pods --namespace assembly-ingress
	kubectl get pods --namespace assembly-ingress -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort
	kubectl --namespace assembly-ingress get ingress

delete-assembly-ingress:
	kubectl delete --all  deployments,services,replicasets,secrets --namespace=assembly-ingress
	kubectl delete namespace assembly-ingress

update-assembly-ingress-version1:
	kubectl -n assembly-ingress set image deployment.apps/assembly-deployment assembly-webapp=harbor.flexlab.local/jmnicolescu/assembly-webapp:1.0
	kubectl -n assembly-ingress rollout status deployment.apps/assembly-deployment
	kubectl get pods --namespace assembly-ingress
	kubectl get pods --namespace assembly-ingress -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

update-assembly-ingress-version2:
	kubectl -n assembly-ingress set image deployment.apps/assembly-deployment assembly-webapp=harbor.flexlab.local/jmnicolescu/assembly-webapp:2.0
	kubectl -n assembly-ingress rollout status deployment.apps/assembly-deployment
	kubectl get pods --namespace assembly-ingress
	kubectl get pods --namespace assembly-ingress -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

update-assembly-ingress-replicas-3:
	kubectl scale deployment.apps/assembly-deployment --replicas=3 --namespace=assembly-ingress
	kubectl get pods --namespace assembly-ingress
	kubectl get pods --namespace assembly-ingress -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort

update-assembly-ingress-replicas-6:
	kubectl scale deployment.apps/assembly-deployment --replicas=6 --namespace=assembly-ingress
	kubectl get pods --namespace assembly-ingress
	kubectl get pods --namespace assembly-ingress -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' | sort
