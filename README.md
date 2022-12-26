# README

## Description
This script consist of commands for MacOS. You can use it to install helm, minikube on your MacOS and deploy argocd and dagster in minikube k8s cluster.


## Deploy demo using demo.sh

Please, run this command to check help menu:

$ demo.sh -h

If you need to install minikube and

If you already have installed minikube and helm, please run the following command to install argocd and dagster:

$ demo.sh -a -d



aws eks update-kubeconfig --region us-east-1 --name test-cluster