# Hands-On Project: Set Up a Production-Like Kubernetes Cluster

Build a Kubernetes cluster with essential add-ons and deploy a sample application.

**Estimated Time:** 4-5 hours
**Difficulty:** Intermediate
**Prerequisites:** kubectl and Helm installed, cloud account or local VM setup

---

## Architecture Overview

```
Kubernetes Cluster
  |
  +-- Control Plane (managed or self-hosted)
  |
  +-- Node Pool (worker nodes)
  |     +-- CNI Plugin (Calico/Cilium)
  |     +-- kube-proxy or eBPF
  |
  +-- Add-ons
  |     +-- Ingress Controller (NGINX)
  |     +-- cert-manager (TLS certificates)
  |     +-- Monitoring (Prometheus + Grafana)
  |     +-- Logging (optional)
  |
  +-- Sample Application
        +-- Deployment + Service + Ingress
        +-- HPA (Horizontal Pod Autoscaler)
```

---

## Option 1: Managed Kubernetes (EKS / AKS / GKE)

### AWS EKS

```bash
# Install eksctl
# https://eksctl.io/installation/

# Create cluster
eksctl create cluster \
  --name my-cluster \
  --region us-east-1 \
  --version 1.29 \
  --nodegroup-name standard-workers \
  --node-type t3.medium \
  --nodes 3 \
  --nodes-min 2 \
  --nodes-max 5 \
  --managed

# Verify
kubectl get nodes
```

**Docs:** https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

### Azure AKS

```bash
# Create resource group
az group create --name myRG --location eastus

# Create cluster
az aks create \
  --resource-group myRG \
  --name my-cluster \
  --node-count 3 \
  --node-vm-size Standard_DS2_v2 \
  --kubernetes-version 1.29 \
  --enable-managed-identity \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group myRG --name my-cluster

kubectl get nodes
```

**Docs:** https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli

### GCP GKE

```bash
# Create cluster
gcloud container clusters create my-cluster \
  --zone us-central1-a \
  --num-nodes 3 \
  --machine-type e2-medium \
  --cluster-version 1.29 \
  --enable-ip-alias

# Get credentials
gcloud container clusters get-credentials my-cluster --zone us-central1-a

kubectl get nodes
```

**Docs:** https://cloud.google.com/kubernetes-engine/docs/deploy-app-cluster

---

## Option 2: Self-Managed with kubeadm

### Prerequisites (on each node)

```bash
# Disable swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

# Load kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Set sysctl parameters
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd

# Install kubeadm, kubelet, kubectl
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

### Initialize Control Plane

```bash
# On the control plane node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubectl access
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Join Worker Nodes

```bash
# On each worker node (use the command from kubeadm init output)
sudo kubeadm join CONTROL_PLANE_IP:6443 --token TOKEN --discovery-token-ca-cert-hash sha256:HASH
```

**Docs:** https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

---

## Step 1: Install CNI Plugin

### Calico

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

# Verify
kubectl get pods -n kube-system -l k8s-app=calico-node
```

**Docs:** https://docs.tigera.io/calico/latest/getting-started/kubernetes/

### Cilium (alternative)

```bash
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --namespace kube-system

# Verify
kubectl get pods -n kube-system -l app.kubernetes.io/name=cilium-agent
```

**Docs:** https://docs.cilium.io/en/stable/gettingstarted/

---

## Step 2: Install Ingress Controller

### NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.replicaCount=2

# Verify
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

**Get the external IP/hostname:**
```bash
kubectl get svc ingress-nginx-controller -n ingress-nginx \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

**Docs:** https://kubernetes.github.io/ingress-nginx/deploy/

---

## Step 3: Install cert-manager

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

# Verify
kubectl get pods -n cert-manager
```

### Configure Let's Encrypt Issuer

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            class: nginx
```

```bash
kubectl apply -f cluster-issuer.yaml
```

**Docs:** https://cert-manager.io/docs/installation/

---

## Step 4: Install Monitoring

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword=admin

# Verify
kubectl get pods -n monitoring
```

See the [monitoring project guide](setup-monitoring-stack.md) for detailed dashboard and alerting setup.

---

## Step 5: Deploy Sample Application

### Deployment

```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
  namespace: default
  labels:
    app: sample-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
        - name: app
          image: nginx:1.25-alpine
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 250m
              memory: 256Mi
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 10
            periodSeconds: 30
```

### Service

```yaml
# app-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: sample-app
  namespace: default
spec:
  selector:
    app: sample-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```

### Ingress

```yaml
# app-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sample-app
  namespace: default
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - app.example.com
      secretName: sample-app-tls
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: sample-app
                port:
                  number: 80
```

### Horizontal Pod Autoscaler

```yaml
# app-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: sample-app
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: sample-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
```

### Apply All Resources

```bash
kubectl apply -f app-deployment.yaml
kubectl apply -f app-service.yaml
kubectl apply -f app-ingress.yaml
kubectl apply -f app-hpa.yaml

# Verify
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl get ingress
kubectl get hpa
```

---

## Step 6: Verify the Setup

```bash
# Check all pods are running
kubectl get pods -A

# Test internal DNS
kubectl run test --rm -it --image=busybox -- nslookup sample-app.default.svc.cluster.local

# Test the application via port-forward
kubectl port-forward svc/sample-app 8080:80
# Open http://localhost:8080

# Check ingress endpoint
curl -v https://app.example.com

# Verify HPA is collecting metrics
kubectl get hpa sample-app
```

---

## Verification Checklist

- [ ] All nodes are in Ready state
- [ ] CNI plugin pods are running on every node
- [ ] Ingress controller is running with an external IP/hostname
- [ ] cert-manager is running and ClusterIssuer is ready
- [ ] Monitoring stack is deployed (Prometheus + Grafana accessible)
- [ ] Sample application deployment has desired replicas running
- [ ] Service endpoints are populated
- [ ] Ingress routes traffic to the application
- [ ] TLS certificate is issued (or pending for real domains)
- [ ] HPA is active and shows current metrics

---

## Cleanup

### Managed Clusters
```bash
# EKS
eksctl delete cluster --name my-cluster --region us-east-1

# AKS
az aks delete --resource-group myRG --name my-cluster --yes

# GKE
gcloud container clusters delete my-cluster --zone us-central1-a
```

### kubeadm Clusters
```bash
# On each node
sudo kubeadm reset
sudo rm -rf /etc/cni/net.d
```

---

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [AKS Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
- [GKE Best Practices](https://cloud.google.com/kubernetes-engine/docs/best-practices)
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [cert-manager Documentation](https://cert-manager.io/docs/)
