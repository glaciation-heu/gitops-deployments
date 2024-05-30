# Integration Cluster

## Available services

| Service                         | URL                                           |
|---------------------------------|-----------------------------------------------|
| ArgoCD                          | http://argocd.integration/                    |
| Data sanitization API           | http://data-sanitization.integration/         |
| Gatekeeper Policy Manager UI    | http://gpm.integration/                       |
| Grafana                         | http://grafana.integration/                   |
| Metadata service                | http://metadata.integration /                 |
| MinIO Glaciation Tenant API     | http://glaciation-tenant.integration/         |
| MinIO Glaciation Tenant Console | http://glaciation-tenant-console.integration/ |
| Spark history server UI         | http://spark-history-server.integration/      |

## How to conect

### VPN

Get a VPN access to the cluster from Dell. There is not direct connectivity without VPN.

### DNS workaround

Our Kubernetes cluster has no DNS server set up yet. 
To override it, add to your file `/etc/hosts` the following configurations:

```
10.14.1.160 argocd.integration
10.14.1.160 data-sanitization.integration
10.14.1.160 glaciation-tenant-console.integration
10.14.1.160 glaciation-tenant.integration
10.14.1.160 gpm.integration
10.14.1.160 grafana.integration 
10.14.1.160 metadata.integration
10.14.1.160 spark-history-server.integration
```

## How to install ArgoCD from scratch

1. Follow official [docs](https://argo-cd.readthedocs.io/en/stable/getting_started/).
2. Apply `argocd-*.yaml` configmaps of our custom configuration.
   ```
   $ kubectl apply -f "argocd-*.yaml" -n=argocd
   ```
3. Use [bootstrap.yaml](bootstrap.yaml) as App-of-Apps configuration.
