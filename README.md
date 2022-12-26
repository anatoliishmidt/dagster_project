# Introduction
There are manifests to build, install and deploy demo project to show you k8s cluster, argocd and dagster demo in this repository. There are two way of run this demo - your laptop and AWS.

Technologies and methodologies that I use here:

Minikube and AWS EKS - tech stack to run k8s cluster (from the requirements of the task).

Terraform - Infrastructure as a code is inportant part of managing infrastructure. I use this method to automate all processes.

ArgoCD - GitOps approach to manage kubernetes deployments and applications as a code and store it in git. I use this method to automate all processes. Also it is easy to manage versions of helm chart. This allows us to use all benefits of GitOps methodology.
> Short remark - in current process we dont have build step (build application or docker image), but we can do it using Argo workflows or any other ci tool (jenkins, github actions etc). So in this case our flow will look like: Argo workflows - builds and puhs to git our code/applications and docker images to the registry, argoCD - deploys and manages k8s things. Of course using webhooks and automate all jobs.

Helm - helps us to manage Kubernetes applications (from the requirements of the task).

Dagster(from the requirements of the task) - Honestly, I'm not familiar with this tool, but after spending some time with documentatoin I understood how it works. So I use a basic example from the documentation and helm chart. I hope this should be enough to show general peacture.

### demo.sh
This script consist of commands for MacOS. You can use it to install helm, minikube on your MacOS and deploy argocd and dagster in k8s cluster.

## Prerequisites
Helm - v3.4.2

k8s cluster (minikube) - v1.19.15

terraform - to work with IaC and AWS.

Configured AWS account with aws-cli access and aws-cli installed - Here I am not specifying anything specific as access can be different. It depends on each team and person (iam role or user etc.).

MacOS - in case with installing helm and minukube.
> If you want to run it on the laptop it should be MacOS(from the requirements of the task). Script can install


## Deploy demo using demo.sh

Please, run this command to check help menu:

`$ demo.sh -h`

If you already have installed minikube(or AWS EKS access) and helm, please run the following command to install argocd and dagster:

`$ demo.sh -a -d`

An example how to install minikube, helm and deploy all stuff:
`$ demo.sh -H "v3.4.2" -m "v1.19.15" -a -d`

If you would like to deploy AWS EKS, please run the following commands to setup it:

`$ cd eks && terraform init`

`$ terraform apply`

To get kubectl config from your eks, please run the following command:

`$ aws eks update-kubeconfig --region us-east-1 --name test-cluster`

After this you can install argocd and dagster using this command:

`$ demo.sh -a -d`

To get the ArgoCD password, please run the following comamnd:

`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

To access the ArgoCD endpoint:

`kubectl port-forward svc/argocd-server -n argocd 8080:443`

## Justifications

All these things from demo were configured using documentations from the requirements list of the task. These are base best practices of modern infrastructure. The main goal is to do our life easier. Simple configuration and all stuff as a code is allow us to take care about all things.
I did not configure load balancers and security things. Because of it is demo and need to spend more time to configure all this stuff deepper. 

To access any endpoint from k8s cluster, please use `kubectl port-forward`. 

As a perspective we can scale all deployments with few replicas to save us from down time and to be HighLoaded. ServiceAccounts of Argocd and Dagster were configured from the helm. Of course we can manage this access using K8s Rbac and AWS IAM(with tokens). All benefits of cloud based infrastructure and infrastructure as a code are allowed us to configure any disaster revcovery - clound availability zones, replications of db and application as a code/infrastructure as code which allow us to deploy all project in few minutes. Also good to have artifactory storage to store and manage helm charts, docker images.