# # # install helm:
wget https://get.helm.sh/helm-v3.4.2-darwin-amd64.tar.gz && tar -xvzf helm-v3.4.2-darwin-amd64.tar.gz && cp ./helm /usr/local/bin/

# # # insall minikube:
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 && \
install minikube-darwin-amd64 /usr/local/bin/minikube && \
minikube start --kubernetes-version=v.1.19.15

# # # install argocd
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f argorepo.yaml

# # # deploy dagster in argocd
kubectl apply -k ./dagster_cl/applications/
