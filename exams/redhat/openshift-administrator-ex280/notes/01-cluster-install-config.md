# 01 - Cluster Install, Config, and Day-2 Operations

## Cluster install paths

EX280 doesn't ask you to install a cluster from scratch (you'll be given a working one), but you should understand the architecture.

### Install methods

| Method | Use case |
|---|---|
| **IPI (Installer-Provisioned)** | Cluster fully managed by openshift-install on AWS, GCP, Azure, vSphere, etc. |
| **UPI (User-Provisioned)** | You provision the infrastructure, OpenShift handles bootstrap |
| **Assisted Installer** | Web-based wizard (cloud or bare metal) |
| **OpenShift Local (CRC)** | Single-node dev cluster on a laptop |
| **ROSA / ARO / OSD** | Managed services (AWS / Azure / Red Hat) |

### Install file: `install-config.yaml`

```yaml
apiVersion: v1
baseDomain: example.com
metadata:
  name: mycluster
networking:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  serviceNetwork:
  - 172.30.0.0/16
controlPlane:
  replicas: 3
  platform: { aws: { type: m5.xlarge } }
compute:
- replicas: 3
  platform: { aws: { type: m5.xlarge } }
platform:
  aws:
    region: us-east-1
pullSecret: '...'
sshKey: '...'
```

---

## Cluster components

You'll inspect these on the exam:

```bash
oc get nodes -o wide
oc get co                                  # Cluster Operators
oc get clusteroperators -o wide
oc get clusterversion
oc adm top nodes
oc adm top pods -A
```

### Cluster Operators (CO)

OpenShift cluster components are deployed and managed by Cluster Operators. Each has an `available`, `progressing`, `degraded` status.

```bash
oc describe co authentication
oc describe co kube-apiserver
oc describe co monitoring
```

If a CO is `degraded`, that's where to look first when troubleshooting.

---

## Node management

### Node roles

- `master` - control plane
- `worker` - workloads
- `infra` - dedicated infra (router, registry, monitoring) - optional

### Cordon / drain / uncordon

```bash
oc adm cordon <node>                      # mark unschedulable
oc adm drain <node> --ignore-daemonsets --delete-emptydir-data
oc adm uncordon <node>                    # mark schedulable again
```

### Add labels and taints

```bash
oc label node <name> node-role.kubernetes.io/infra=
oc adm taint nodes <name> dedicated=infra:NoSchedule
```

### Machine API

OpenShift uses the Machine API to manage nodes via MachineSets:

```bash
oc -n openshift-machine-api get machineset
oc -n openshift-machine-api get machine
oc -n openshift-machine-api scale machineset/<name> --replicas=5
```

---

## MachineConfig and MachineConfigPool

MCO (Machine Config Operator) manages node OS configuration via MachineConfigs. Common admin tasks:

- Configure chrony / time sync on nodes
- Add SSH keys to core user
- Customize kubelet config
- Install custom certificates

Example: enable chrony:

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker
  name: 99-worker-chrony
spec:
  config:
    ignition: { version: 3.2.0 }
    storage:
      files:
      - contents:
          source: data:text/plain;charset=utf-8;base64,...
        mode: 0644
        path: /etc/chrony.conf
        overwrite: true
```

MCO will roll the MachineConfigPool, rebooting nodes one at a time. Watch with `oc get mcp`.

---

## Cluster certificates

Most cluster certs are auto-rotated. The default ingress certificate is the most commonly customized.

```bash
# View the current ingress cert
oc get -n openshift-ingress secret router-ca -o yaml

# Replace ingress cert
oc create secret tls custom-ingress \
    --cert=fullchain.pem --key=privkey.pem \
    -n openshift-ingress
oc patch ingresscontroller default -n openshift-ingress-operator \
    --type=merge -p '{"spec":{"defaultCertificate":{"name":"custom-ingress"}}}'
```

---

## Cluster upgrades (high-level)

```bash
oc get clusterversion                       # current and available channels
oc adm upgrade                              # show available upgrades
oc adm upgrade --to=4.14.10                # upgrade to specific version
oc adm upgrade channel stable-4.14         # change channel
```

Watch the upgrade:

```bash
oc get co
oc get nodes
oc get mcp
```

A successful upgrade has all COs `available=true`, `progressing=false`, `degraded=false`.

---

## Common day-2 admin tasks

### Add a worker node (cloud-managed)

```bash
oc -n openshift-machine-api get machineset
oc -n openshift-machine-api scale machineset/<name> --replicas=5
```

Watch:

```bash
oc -n openshift-machine-api get machines -w
oc get nodes -w
```

### Drain a node for maintenance

```bash
oc adm cordon <node>
oc adm drain <node> --ignore-daemonsets --delete-emptydir-data
# do maintenance
oc adm uncordon <node>
```

### Replace the cluster default ingress cert

(See certificates section above.)

### Trigger an etcd backup

On a control plane node:

```bash
sudo /usr/local/bin/cluster-backup.sh /home/core/backup
```

Result: snapshot.db and static-kuberesources_<timestamp>.tar.gz in the dir.

---

## Troubleshooting

### When something is broken

1. `oc get co` - any degraded?
2. `oc get nodes` - all Ready?
3. `oc get pods -A | grep -v Running | grep -v Completed`
4. `oc describe pod <bad-pod>` - look at Events
5. `oc logs <pod> [-c container]`
6. `oc adm must-gather` - capture broad diagnostic for support

### Pod won't start

- ImagePullBackOff → check image name, registry pull secrets
- CrashLoopBackOff → check logs, exit code
- Pending → check events for scheduling reason (resources, taints, PVC)
- Init:Error → init container failing; check logs

### Node not Ready

```bash
oc describe node <name>
oc debug node/<name>
# inside the debug pod:
chroot /host
systemctl status kubelet
journalctl -u kubelet --since '15 minutes ago'
```

---

## Verification checklist

After cluster-level changes:

- `oc get co` - all available, none progressing or degraded
- `oc get nodes` - all Ready
- `oc get clusterversion` - desired version achieved
- `oc adm top nodes` - reasonable resource usage
