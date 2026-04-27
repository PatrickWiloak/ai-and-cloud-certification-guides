# EX280 - 15 Hands-On Scenarios

These mirror the format of EX280 tasks. Each is a hands-on objective; complete on a live OpenShift cluster.

Time yourself. Aim for 8-12 minutes per scenario.

---

## Scenario 1 - Configure HTPasswd identity provider

Add two HTPasswd users (`alice/secret` and `bob/secret2`) to the cluster. Make alice a cluster-admin.

<details>
<summary>Solution</summary>

```bash
htpasswd -c -B -b users.htpasswd alice secret
htpasswd -B -b users.htpasswd bob secret2

oc create secret generic htpass-secret \
    --from-file=htpasswd=users.htpasswd \
    -n openshift-config

oc edit oauth cluster
# Add:
# spec:
#   identityProviders:
#   - name: my_htpasswd
#     mappingMethod: claim
#     type: HTPasswd
#     htpasswd:
#       fileData:
#         name: htpass-secret

# Wait ~30s for OAuth pods to roll
oc -n openshift-authentication get pods

oc adm policy add-cluster-role-to-user cluster-admin alice

oc login -u alice -p secret
oc whoami
```
</details>

---

## Scenario 2 - Create project with quota and limits

Create project `production`. Quota: 4 CPU requests, 8 GB memory requests, 10 PVCs, 20 pods. LimitRange: per-container default 200m/256Mi request, 1/1Gi limit.

<details>
<summary>Solution</summary>

```bash
oc new-project production --description='Production' --display-name='Production'

cat <<EOF | oc apply -f -
apiVersion: v1
kind: ResourceQuota
metadata:
  name: production-quota
  namespace: production
spec:
  hard:
    requests.cpu: '4'
    requests.memory: 8Gi
    persistentvolumeclaims: '10'
    pods: '20'
---
apiVersion: v1
kind: LimitRange
metadata:
  name: production-limits
  namespace: production
spec:
  limits:
  - type: Container
    defaultRequest: { cpu: 200m, memory: 256Mi }
    default: { cpu: '1', memory: 1Gi }
EOF

oc -n production describe quota
oc -n production describe limitrange
```
</details>

---

## Scenario 3 - Grant RBAC roles

Make user `bob` a project admin in `production`. Grant `charlie` only view access.

<details>
<summary>Solution</summary>

```bash
oc adm policy add-role-to-user admin bob -n production
oc adm policy add-role-to-user view charlie -n production

# Verify
oc auth can-i create deployments --as=bob -n production
oc auth can-i delete pods --as=charlie -n production       # should be no
oc auth can-i get pods --as=charlie -n production          # should be yes
```
</details>

---

## Scenario 4 - Deploy and expose an app

In `production`, deploy nginx with 3 replicas, expose at `nginx.apps.example.com` over edge-terminated TLS, redirecting HTTP to HTTPS.

<details>
<summary>Solution</summary>

```bash
oc -n production new-app docker.io/nginx --name=nginx
oc -n production scale deploy/nginx --replicas=3

oc -n production expose deploy/nginx --port=80
oc -n production create route edge nginx \
    --service=nginx \
    --hostname=nginx.apps.example.com \
    --insecure-policy=Redirect

oc -n production get routes
curl -I https://nginx.apps.example.com
```
</details>

---

## Scenario 5 - Persistent storage

Add a 5 GB ReadWriteOnce PVC to the nginx deployment, mounted at `/usr/share/nginx/html`.

<details>
<summary>Solution</summary>

```bash
oc -n production set volume deploy/nginx \
    --add --type=pvc \
    --claim-class=gp3-csi \
    --claim-size=5Gi \
    --claim-mode=ReadWriteOnce \
    --mount-path=/usr/share/nginx/html

oc -n production get pvc
oc -n production rollout status deploy/nginx
oc -n production rsh deploy/nginx df -h /usr/share/nginx/html
```
</details>

---

## Scenario 6 - NetworkPolicy: default deny + allow frontend

In `production`, deploy two apps with labels `app=frontend` and `app=backend`. Configure: backend only accepts ingress from frontend pods.

<details>
<summary>Solution</summary>

```bash
oc -n production new-app docker.io/nginx --name=frontend -l app=frontend
oc -n production new-app docker.io/nginx --name=backend -l app=backend

cat <<EOF | oc -n production apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {}
  policyTypes: [Ingress]
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
spec:
  podSelector: { matchLabels: { app: backend } }
  policyTypes: [Ingress]
  ingress:
  - from:
    - podSelector: { matchLabels: { app: frontend } }
EOF

oc -n production get netpol
# Test:
# oc rsh deploy/frontend -- curl backend             (should work)
# oc run test --image=curlimages/curl --rm -it -- /bin/sh -c "curl backend.production"   (should fail)
```
</details>

---

## Scenario 7 - Install an operator

Install the OpenShift Pipelines operator from OperatorHub via YAML.

<details>
<summary>Solution</summary>

```bash
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators
spec:
  channel: latest
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
EOF

# Wait
oc get csv -n openshift-operators -w
oc get pods -n openshift-operators
```
</details>

---

## Scenario 8 - Configure cluster monitoring

Enable user-workload monitoring with 15-day Prometheus retention.

<details>
<summary>Solution</summary>

```bash
cat <<EOF | oc apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
    prometheusK8s:
      retention: 15d
EOF

oc -n openshift-user-workload-monitoring get pods
```
</details>

---

## Scenario 9 - Custom storage class

Create a new StorageClass `gp3-encrypted` with EBS gp3, encrypted, and make it the cluster default.

<details>
<summary>Solution</summary>

```bash
cat <<EOF | oc apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-encrypted
  annotations:
    storageclass.kubernetes.io/is-default-class: 'true'
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  encrypted: 'true'
allowVolumeExpansion: true
reclaimPolicy: Delete
EOF

# Remove default annotation from old default
oc annotate storageclass gp3-csi storageclass.kubernetes.io/is-default-class-

oc get sc
```
</details>

---

## Scenario 10 - Cordon and drain a node

Cordon worker node `worker-2`, drain it, do "maintenance" (just sleep), then bring it back.

<details>
<summary>Solution</summary>

```bash
oc adm cordon worker-2
oc adm drain worker-2 --ignore-daemonsets --delete-emptydir-data
# Maintenance window:
# (do whatever)
oc adm uncordon worker-2
oc get nodes
```
</details>

---

## Scenario 11 - Restrict project creation

Restrict project creation so only cluster admins can create new projects.

<details>
<summary>Solution</summary>

```bash
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth

# Verify (as a regular user)
oc login -u alice -p secret
oc new-project test    # should fail
```

To re-enable later:

```bash
oc adm policy add-cluster-role-to-group self-provisioner system:authenticated:oauth
```
</details>

---

## Scenario 12 - SCC for legacy app

Deploy an image that requires running as a specific UID (anyuid). Grant the necessary SCC to the service account.

<details>
<summary>Solution</summary>

```bash
oc -n production create sa legacy-app
oc adm policy add-scc-to-user anyuid -z legacy-app -n production

cat <<EOF | oc apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: legacy
  namespace: production
spec:
  replicas: 1
  selector: { matchLabels: { app: legacy } }
  template:
    metadata: { labels: { app: legacy } }
    spec:
      serviceAccountName: legacy-app
      containers:
      - name: legacy
        image: docker.io/some-legacy-image
EOF

oc -n production get pods
```
</details>

---

## Scenario 13 - Configure cluster autoscaling (Machine API)

Scale a worker MachineSet from 3 to 5 replicas.

<details>
<summary>Solution</summary>

```bash
oc -n openshift-machine-api get machineset
oc -n openshift-machine-api scale machineset/<name> --replicas=5

oc -n openshift-machine-api get machine
# Wait for new nodes
oc get nodes -w
```
</details>

---

## Scenario 14 - Backup and restore an ETCD snapshot

Take an etcd backup on a control plane node.

<details>
<summary>Solution</summary>

```bash
# SSH to a control plane node, OR oc debug node/<master>
oc debug node/<master>
chroot /host

# Run cluster backup script
sudo /usr/local/bin/cluster-backup.sh /home/core/backup

# Confirm
ls /home/core/backup
# snapshot_<date>.db, static_kuberesources_<date>.tar.gz
```
</details>

---

## Scenario 15 - Diagnose a broken pod

A deployment in `production` has 5 replicas but only 2 are running. Find why and fix.

<details>
<summary>Solution</summary>

```bash
oc -n production get deployments
oc -n production get pods -o wide
oc -n production describe pod <one-failing>
# Read Events section. Common causes:
# - PVC unbound  → fix PVC
# - ImagePullBackOff → check image name / pull secret
# - SCC violation → grant SCC to SA
# - Insufficient resources on nodes → scale node count or reduce replica resources

oc -n production logs <one-failing>      # for crashed/crashing
oc -n production logs -p <one-failing>   # previous container if crash-looping
```

Apply fix, then:

```bash
oc -n production rollout restart deploy/<name>
oc -n production get pods -w
```
</details>

---

## Scoring guide

- **All 15 in <2 hours, no notes:** ready to schedule the exam.
- **12-14 in 2-3 hours:** one more week of practice on weak areas.
- **<12, or you needed notes:** keep practicing. EX280 is performance-based; reading isn't enough.

The real exam has roughly 15-20 tasks in 3 hours. If you can do these 15 in 2 hours, you have buffer for verification and harder real-exam tasks.
