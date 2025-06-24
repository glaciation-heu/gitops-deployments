## Section&nbsp;5 – GLACIATION Platform Deployment Procedures (HIRO)

> **Prereqs**  
> * Kubernetes ≥ 1.27 (fresh cluster)  
> * CLI tools: `kubectl`, `argocd`
> * Cluster CD: preinstalled `argo-cd`
> * Cluster-admin context, outbound Internet access  

---

### 5.1 General Deployment Strategy  

1. **GitOps with Argo CD Applications** – the repo follows an *app-of-apps* bootstrap (`integration-cluster.yaml`, `validation-cluster.yaml`).  
2. **Branch flow** –  
   * `main` = long-lived source  
   * `deploy` = fast-forward-only; watched by Argo (`targetRevision: deploy`).  
3. **Phased rollout** – Integration → Validation. Promote by merging a PR that bumps the image tag or Helm chart version in Overlay.  
4. **CI/CD glue** – a GitHub Actions job *Build Kustomize Bundle* must succeed before `deploy` can advance.  

---

### 5.2 Step-by-Step Installation Guide for Core Components  

> **Convention:** every step is its own Argo `Application` under `base/<component>` with environment overlays in `overlays/<env>/<component>`. 

> **Prefferable approach:** It´s not expected that you will install everything separately, several components rely on each-other. You should and must install everything using bootstrap yaml's(`integration-cluster.yaml`, `validation-cluster.yaml`). 

```bash
# Apply required manual manifests
kubectl apply -k base/apps/base/manual
kubectl apply -f integration-cluster.yaml
```


#### 5.2.1 Base Deployment 

```bash
# Control-plane add-ons (CRDs, RBAC, cert-manager, ingress-nginx …)
kubectl apply -k base/apps/base/manual
kubectl apply -k base/apps/base
kubectl apply -k overlays/$ENV/base
```

Verify:
```bash
kubectl get pods -n longhorn-system
kubectl get pods -n ingress-nginx
kubectl get pods -n dkg-engine
```


#### 5.2.2 Kernel Deployment  

```bash
kubectl apply -k base/apps/base/kernel
kubectl apply -k overlays/$ENV/kernel
```

Verify:
```bash
kubectl get pods -n kube-system
```

#### 5.2.3 DKG & Micro-services Deployment  

```bash
kubectl apply -k base/apps/base/dkg-engine
kubectl apply -k overlays/$ENV/dkg-engine
```
Creates the Distributed Knowledge Graph, Postgres backend, and edge APIs.

#### 5.2.4 AI Engine Deployment  

```bash
kubectl apply -k base/apps/base/ai-decision-engine
kubectl apply -k overlays/$ENV/ai-decision-engine
```
Installs Decision Engine, Inference Serving, Trade-Off Service.

#### 5.2.5 Energy-Management Framework Deployment  

?????????

#### 5.2.6 Protection Techniques Module Deployment  

```bash
kubectl apply -k base/apps/base/security
kubectl apply -k overlays/$ENV/security
```

---

### 5.3 Configuration of Platform Components  

#### 5.3.1 Key Configuration Files & Parameters  
* Each `kustomization.yaml` allow to patch version of a `helm` chart and `values.yaml` in it. 
* Example: `overlays/validation/base/patch-optional.yaml` patches nginx `external-status-address`.

#### 5.3.2 Environment Variables  

??????? We don't have one?

#### 5.3.3 Scenario-specific Configuration  
* Can always add overlay for each scenario, need to modify Github CI workflow to add `overlay` into `matrix`, and add new ArgoCD application, e.g. `specific-scenario-name.yaml`

---

### 5.4 Data Ingestion & Initial Setup  

??????
#### 5.4.1 Setting up Metadata Services  

????

#### 5.4.2 Initializing Data Storage  

??????????

Longhorn and Minio do the job above.

---

### 5.5 Verification of Successful Deployment  

#### 5.5.1 Sanity Checks & Health Endpoints  

```bash
argocd app list           # all apps Healthy & Synced
kubectl get ingress -A    # routes: argocd.$DOMAIN, api.$DOMAIN …
```

#### 5.5.2 Basic Functional Tests Post-Deployment  

????????????

---

### Appendices  

* **Load-balancer quick-start** – minimal nginx reverse-proxy for PoCs.  
* **DNS/VPN debugging** – `nslookup` tips for off-VPN troubleshooting.  
