#!/bin/bash

while getopts H:m:adrh flag
do
    case "${flag}" in
        H)
            #if you like to install helm on your MacOS 
            helmVersion=${OPTARG}
            wget https://get.helm.sh/helm-$helmVersion-darwin-amd64.tar.gz
            tar -xvzf helm-$helmVersion-darwin-amd64.tar.gz
            cp ./darwin-amd64/helm /usr/local/bin/
            ;;
        m) 
            #if you like to install minikube on your MacOS
            kubeVersion=${OPTARG}
            curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
            install minikube-darwin-amd64 /usr/local/bin/minikube
            minikube start --kubernetes-version=$kubeVersion
            ;;
        a)
            #install argocd in your minikube k8s cluster
            kubectl create ns argocd
            kubectl apply -n argocd -f argocd.yaml
            kubectl rollout status deployment argocd-server -n argocd --timeout=90s
            kubectl rollout status deployment argocd-repo-server -n argocd --timeout=90s
            kubectl rollout status deployment argocd-applicationset-controller -n argocd --timeout=90s
            kubectl apply -n argocd -f argorepo.yaml
            ;;
        d)
            #install dagster as a argocd application
            kubectl apply -k ./dagster_cl/applications/
            ;;
        r)
            kubectl delete -k ./dagster_cl/applications/
            kubectl delete -n argocd -f argocd.yaml
            kubectl delete ns argocd
            ;;
        h)
            echo """
            demo.sh -   bash script to show you deployment and installation of set of tools - helm/minikube/argocd/
                        this script should be run on MacOS
                Options:
                    -H      Install helm on your MacOS. Need to provide version of Helm. Example: -H \"v3.4.2\"
                    -m      Install minikube on your MacOS. Need to provide k8s version. Example: -m \"v1.19.15\"
                    -a      Enable installing argocd in your minikube.
                    -d      Apply the ArgoCD applications from repository.
                    -r      Remove argocd applications and argocd itself.
                    -h      Help menu.
            """
            exit 0
            ;;
        *)
            echo "Incorrect option provided"
            exit 1
            ;;
    esac
done