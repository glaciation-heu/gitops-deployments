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
| Vault UI                        | https://vault.integration/                    |

## How to connect

### VPN

Get a VPN access to the cluster from Dell. There is no direct connectivity without VPN.

### DNS workaround

Our Kubernetes cluster has no DNS set up yet. To override it, add to your [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) the following configurations:

```
10.14.1.160 argocd.integration
10.14.1.160 data-sanitization.integration
10.14.1.160 glaciation-tenant-console.integration
10.14.1.160 glaciation-tenant.integration
10.14.1.160 gpm.integration
10.14.1.160 grafana.integration 
10.14.1.160 metadata.integration
10.14.1.160 spark-history-server.integration
10.14.1.160 vault.integration
```

## Initial configuration

### Traffic routing

The diagram demonstrates traffic routing from web client to application running in cluster.  

![traffic-routing.drawio.svg](docs/traffic-routing.drawio.svg)

Ingress controller is mapped to a master node port 31080. It is not the best practice. We use this approach for a quick start. Consider to use the best practices.

Load balancer is a manually installed Nginx. Check [load-balancer](load-balancer) for more details.

### ArgoCD

How to install ArgoCD.

1. Follow official [docs](https://argo-cd.readthedocs.io/en/stable/getting_started/).
2. Apply `argocd-*.yaml` configmaps of our custom configuration.
   ```
   $ kubectl apply -f "argocd-*.yaml" -n=argocd
   ```
3. Use *.yaml as App-of-Apps configurations.
