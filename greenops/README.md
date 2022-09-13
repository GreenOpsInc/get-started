## Linting

```bash
helm lint ./greenops
```

## Packaging

```bash
helm package ./greenops
```

## Installing

### Required fields

 - `common.licenseKey`: Greenops license key
 - `server.externalUrl`: Greenops server external URL (should be configured with Ingress)
 - `server.sso.clientId`: Dex SSO client id
 - `server.sso.clientSecret`: Dex SSO client secret
 - `common.argoCdUrl`: ArgoCD external URL (for SSO authentication with Dex)
 - `common.usePersistentVolume`: Whether we should create configuration for Redis persistent volume (default is true)

### Optional fields

Configure redis instance with PVC (you should use those arguments if deploying to GCP with Persistent Volumes):

 - `common.dbAddress`: Redis DB address
 - `redis.volume.persistentVolume.labels.topology.kubernetes.io/region`: GCP account region
 - `redis.volume.persistentVolume.labels.topology.kubernetes.io/zone`: GCP account zone
 - `redis.volume.persistentVolume.labels.type`: PV type (default is `local`)
 - `redis.volume.persistentVolume.gcePersistentDisk.pdName`: GCE Persistent disk name
 - `redis.volume.persistentVolume.gcePersistentDisk.fsType`: GCE Persistent file system type

Configure regcred secret:

- `common.imageCredentials.username`: Registry user's username
- `common.imageCredentials.password`: Registry user's password
- `common.imageCredentials.email`: Registry user's email

Example:

```bash
helm install greenops ./greenops-<version>.tgz \
  --set 'common.licenseKey=licensekey' \
  --set 'common.dbAddress=192.168.64.5:30588' \
  --set 'server.externalUrl=greenops-server.io:8080' \
  --set 'server.sso.clientId=greenops-sso' \
  --set 'server.sso.clientSecret=client-secret' \
  --set 'common.argoCdUrl=argocd.apps.argoproj.io' \
  --set 'common.imageCredentials.username=username' \
  --set 'common.imageCredentials.password=password' \
  --set 'common.imageCredentials.email=email'
```

## Updating

Example:

```bash
helm upgrade --install greenops ./greenops-<version>.tgz \
  --set 'common.licenseKey=licensekey' \
  --set 'common.dbAddress=192.168.64.5:30588' \
  --set 'server.externalUrl=greenops-server.io:8080' \
  --set 'server.sso.clientId=greenops-sso' \
  --set 'server.sso.clientSecret=client-secret' \
  --set 'common.argoCdUrl=argocd.apps.argoproj.io' \
  --set 'common.imageCredentials.username=username' \
  --set 'common.imageCredentials.password=password' \
  --set 'common.imageCredentials.email=email'
```
