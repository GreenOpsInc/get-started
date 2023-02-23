kubectl delete all --all -n dex

kubectl delete namespace dex

kubectl create namespace dex

helm package .

helm install dex ./greenops-dex-4.10.7.tgz --namespace dex
