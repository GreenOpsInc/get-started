# Configuring ingress for GreenOps

GreenOps relies on some SSH protocols to provide a smooth, unified Argo experience. A single TCP port should be enabled in your ingress controller to allow this.

## Using NGINX Community Edition
Apply the `tcp-configuration.yaml` file in this repository to the namespace where the ingress controller is deployed:
```
kubectl apply -f tcp-configuration.yaml -n <INGRESS_NAMESPACE>
```

Update the controller deployment to include this flag: `--tcp-services-configmap` in the arguments section. It is used to point towards the ConfigMap that was just created and add TCP port 22 to your ingress configuration. An example is:
```
--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services
```
***Note:*** *Do not update `$(POD_NAMESPACE)`. That is meant to be a dynamic variable.*

This will point all TCP traffic to GreenOps servers, so GreenOps can connect all your Argo instances.

### Security
All agents and servers are fully configured with secure authorized keys. Unknown hosts attempting to access the TCP port will be denied instantly.
