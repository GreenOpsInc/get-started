#!/bin/bash
echo "This script deploys Argo CD, Argo Workflows, and the main GreenOps control plane. The GreenOps Daemon can be deployed using the start-daemon.sh script."
sleep 10
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/quick-start-postgres.yaml
kubectl create ns greenops
echo -n "Set up the GreenOps SSO secret. Enter an alphanumeric (uppercase and lowercase are fine) client-id that you would like to use. If nothing is entered, a default value will be used."
read -s sso_client_id
if [ -z "$sso_client_id" ]; then sso_client_id=Z3JlZW5vcHMtc3Nv; fi;
echo -n "Please enter an alphanumeric secret/token (uppercase and lowercase are fine) that you would like to use. If nothing is entered, a default value will be used.":
read -s sso_key
if [ -z "$sso_key" ]; then sso_key=FdsqnN7HXp3d9b4V6nhtzcW9jghNDEZYN3bJUFfLEP95QsxGKgd67X4Q7ScR9ztV; fi;
kubectl create secret generic greenops-sso --from-literal=client-id=$sso_client_id --from-literal=client-secret=$sso_key -n greenops
kubectl create secret generic greenops-sso --from-literal=client-id=$sso_client_id --from-literal=client-secret=$sso_key -n argocd
kubectl patch deployment argocd-dex-server -n argocd -p '{"spec":{"template":{"spec":{"containers":[{"env":[{"name":"GREENOPS_SSO_CLIENT_SECRET","valueFrom":{"secretKeyRef":{"name":"greenops-sso", "key":"client-secret"}}}],"name":"dex"}]}}}}'
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl patch svc argo-server -n argo -p '{"spec": {"type": "NodePort"}}'
echo -n "GreenOps also needs a valid license to activate. Please enter the license":
read -s golicense
kubectl create secret generic greenops-license --from-literal=key=$golicense -n greenops
echo "Waiting for all the Argo CD pods to be marked as ready, this might take a minute..."
sleep 5
kubectl wait --for=condition=ready pod --all --timeout=-1s -n argocd
sleep 5
argocd_admin_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
kubectl create secret generic argocd-user --from-literal=username=admin --from-literal=password=$argocd_admin_password -n greenops
kubectl create secret generic argocd-user --from-literal=username=admin --from-literal=password=$argocd_admin_password -n argo
echo -n "What address will GreenOps be exposed at?"
read greenops_ip
echo -n "What address will Argo CD be exposed at?"
read argocd_ip
kubectl patch deployment argo-server -n argo -p '{"spec":{"template":{"spec":{"containers":[{"args":["server", "--namespaced", "--auth-mode", "server", "--auth-mode", "client", "--x-frame-options", "allow-from '"$greenops_ip"'"],"name":"argo-server"}]}}}}'
echo -n "Do you want the script to set up the Argo CD Dex instance (if no, it will have to be done manually)? The script sets up Dex with Github by default.
Type \"y\" for yes or nothing for no":
read dex_setup_response
if [ ! -z "$dex_setup_response" ]
then
  echo -n "Enter the Github organization name":
  read git_org_name
  echo -n "Enter the Github organization's client ID":
  read git_client_id
  echo -n "Enter the Github organization's client secret":
  read -s git_client_secret
  echo "
  kind: ConfigMap
  apiVersion: v1
  metadata:
    labels:
      app.kubernetes.io/name: argocd-cm
      app.kubernetes.io/part-of: argocd
    name: argocd-cm
  data:
    dex.config: |
      connectors:
        - type: github
          id: github
          name: GitHub
          config:
            clientID: $git_client_id
            clientSecret: $git_client_secret
            orgs:
            - name: $git_org_name
      # Setting staticClients allows ArgoWorkflows to use ArgoCD's Dex installation for authentication
      staticClients:
        - id: greenops-sso
          name: GreenOps SSO
          redirectURIs:
            - https://$greenops_ip/oauth2/callback
          secretEnv: GREENOPS_SSO_CLIENT_SECRET
    url: https://$argocd_ip
    " | kubectl apply -n argocd -f -
    pod_to_delete=$(kubectl get pods -n argocd --no-headers | awk '{print $1}' | grep argocd-server | tr '\n' ' ')
    kubectl delete pod $pod_to_delete -n argocd
    pod_to_delete=$(kubectl get pods -n argocd --no-headers | awk '{print $1}' | grep argocd-dex-server | tr '\n' ' ')
    kubectl delete pod $pod_to_delete -n argocd
fi
kubectl wait --for=condition=ready pod --all -n argo
kubectl wait --for=condition=ready pod --all -n argocd

# Start GreenOps
echo "Create secret to access Docker images"
echo -n "Docker account email":
read docker_email
echo -n "Docker account username":
read docker_username
echo -n "Docker account password":
read -s docker_password

helm install greenops ./greenops-0.1.0.tgz \
  --set 'common.licenseKey='"$golicense"'' \
  --set 'common.dbAddress=redisserver.greenops.svc.cluster.local:6379' \
  --set 'server.externalUrl='"$(minikube ip)"'' \
  --set 'server.sso.clientId=greenops-sso' \
  --set 'server.sso.clientSecret='"$sso_key"'' \
  --set 'common.argoCdUrl='"$argocd_ip"'' \
  --set 'common.imageCredentials.username='"$docker_username"'' \
  --set 'common.imageCredentials.password='"$docker_password"'' \
  --set 'common.imageCredentials.email='"$docker_email"''
