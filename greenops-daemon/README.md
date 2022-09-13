## Linting

```bash
helm lint ./greenops-daemon
```

## Packaging

```bash
helm package ./greenops-daemon
```

## Installing

Base arguments:

- `clusterName`: Cluster name
- `greenopsApiKey`: Greenops cluster ApiKey
- `apis.commandDelegatorApi`: Greenops command delegator API (default is `greenops-commanddelegator.greenops.svc.cluster.local`)
- `apis.greenopsServerUrl`: Greenops command delegator API (default is `greenops-server.greenops.svc.cluster.local`)
- `apis.argo.workflows.url`: Argo Workflows URL

Configure regcred secret:

- `imageCredentials.username`: Registry user's username
- `imageCredentials.password`: Registry user's password
- `imageCredentials.email`: Registry user's email

Example:

```bash
helm install greenops-daemon ./greenops-daemon-<version>.tgz \
  --set 'clusterName=cluster-1' \
  --set 'greenopsApiKey=greenopsapikey' \
  --set 'apis.argo.workflows.url=workflows.apps.argoproj.io' \
  --set 'imageCredentials.username=username' \
  --set 'imageCredentials.password=password' \
  --set 'imageCredentials.email=email'
```

## Updating

Example:

```bash
helm upgrade --install greenops-daemon ./greenops-daemon-<version>.tgz \
  --set 'clusterName=cluster-1' \
  --set 'greenopsApiKey=greenopsapikey' \
  --set 'apis.argo.workflows.url=workflows.apps.argoproj.io' \
  --set 'imageCredentials.username=username' \
  --set 'imageCredentials.password=password' \
  --set 'imageCredentials.email=email'
```
