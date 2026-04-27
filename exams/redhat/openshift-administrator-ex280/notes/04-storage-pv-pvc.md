# 04 - Storage: PVs, PVCs, StorageClasses

## Storage model

OpenShift inherits Kubernetes storage:

- **PersistentVolume (PV)** - cluster-scoped storage resource (an actual disk / NFS share / cloud volume).
- **PersistentVolumeClaim (PVC)** - namespace-scoped request for storage.
- **StorageClass (SC)** - template for dynamically provisioning PVs.
- **CSI driver** - Container Storage Interface driver that knows how to talk to the actual storage backend.

---

## Access modes

| Mode | Meaning |
|---|---|
| **ReadWriteOnce (RWO)** | Mount on one node read-write |
| **ReadOnlyMany (ROX)** | Many nodes mount read-only |
| **ReadWriteMany (RWX)** | Many nodes mount read-write (requires NFS, CephFS, etc.) |
| **ReadWriteOncePod (RWOP)** | Single pod read-write |

EBS / Azure Disk / vSphere volumes are RWO. NFS / Ceph FS / Azure File can be RWX.

---

## Reclaim policies

When a PVC is deleted, what happens to the PV / underlying storage:

- **Delete** - PV and underlying storage destroyed (typical for dynamic provisioning)
- **Retain** - PV kept; admin must manually clean up
- **Recycle** - deprecated, do not use

---

## Storage classes (cloud common)

```bash
oc get storageclass
oc get sc                                # alias
oc describe sc gp3-csi
```

| Cloud / Platform | Common SC name | Backend |
|---|---|---|
| ROSA on AWS | `gp3-csi`, `gp2-csi` | EBS via AWS EBS CSI driver |
| ARO on Azure | `managed-csi`, `managed-csi-encrypted` | Azure Disk |
| OpenShift on vSphere | `thin-csi` | vSphere CSI |
| OCS / ODF | `ocs-storagecluster-ceph-rbd`, `ocs-storagecluster-cephfs` | Ceph RBD (RWO) / CephFS (RWX) |

### Set default storage class

```bash
oc patch storageclass gp3-csi \
    -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Remove default annotation from another
oc patch storageclass gp2-csi \
    -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

---

## PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data
  namespace: myapp
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp3-csi              # optional; uses default if omitted
```

```bash
oc apply -f pvc.yaml
oc get pvc
oc describe pvc data
```

If the StorageClass exists and supports the requested access mode, a PV is dynamically provisioned and the PVC reaches `Bound` status.

---

## Mounting a PVC in a pod / deployment

### Method 1: `oc set volume`

```bash
oc set volume deploy/web \
    --add --type=pvc \
    --claim-name=data \
    --mount-path=/var/lib/data \
    --name=data-volume
```

### Method 2: Deployment YAML

```yaml
spec:
  template:
    spec:
      containers:
      - name: web
        image: nginx
        volumeMounts:
        - name: data
          mountPath: /var/lib/data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: data
```

### Quick PVC + mount (one command)

```bash
oc set volume deploy/web \
    --add --type=pvc \
    --claim-class=gp3-csi \
    --claim-size=5Gi \
    --mount-path=/var/lib/data
```

This both creates a PVC and mounts it. Useful for the exam.

---

## Static provisioning (NFS example)

Sometimes you'll be given an NFS share to use directly.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv-shared
spec:
  capacity:
    storage: 10Gi
  accessModes: [ReadWriteMany]
  persistentVolumeReclaimPolicy: Retain
  nfs:
    server: nfs.example.com
    path: /exports/shared
  storageClassName: ''                   # empty = no class
```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-shared
  namespace: myapp
spec:
  accessModes: [ReadWriteMany]
  resources:
    requests: { storage: 10Gi }
  storageClassName: ''
  volumeName: nfs-pv-shared              # bind to specific PV
```

---

## Volume expansion

If the StorageClass has `allowVolumeExpansion: true`, you can grow a PVC:

```bash
oc edit pvc data
# Change spec.resources.requests.storage from 5Gi to 10Gi
```

The CSI driver expands the underlying volume. The pod may need a restart for the filesystem to grow (`oc rollout restart deploy/web`).

```bash
oc get pvc data
# STATUS should be Bound; CAPACITY shows new size after expansion completes
```

---

## ReadWriteMany (RWX) options

When you need many pods to write to the same volume:

| Backend | OpenShift StorageClass |
|---|---|
| **NFS** | Self-hosted or cloud NFS (FSx ONTAP, Azure Files) |
| **CephFS** | OpenShift Data Foundation `ocs-storagecluster-cephfs` |
| **AWS EFS** | AWS EFS CSI Driver Operator |
| **Azure Files** | `azurefile-csi` |

For most exam scenarios, RWO with EBS-class storage is what you'll use.

---

## Common storage exam tasks

### Provision 5 GB persistent storage for a deployment

```bash
oc set volume deploy/web \
    --add --type=pvc \
    --claim-class=gp3-csi \
    --claim-size=5Gi \
    --claim-mode=ReadWriteOnce \
    --mount-path=/var/lib/data
```

### Make `gp3-csi` the default storage class

```bash
oc patch storageclass gp3-csi \
    -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Verify
oc get sc                              # one should have (default) suffix
```

### Mount an existing PVC into a pod

```yaml
spec:
  containers:
  - name: app
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: existing-pvc
```

### Expand a PVC from 5 GB to 10 GB

```bash
oc edit pvc data
# change resources.requests.storage to 10Gi

# Or:
oc patch pvc data -p '{"spec":{"resources":{"requests":{"storage":"10Gi"}}}}'

oc rollout restart deploy/web         # so pod sees new size
```

### Set up an NFS mount with a specific PV

Apply the static PV + PVC YAML pair above.

---

## Troubleshooting storage

### PVC stuck in `Pending`

```bash
oc describe pvc <name>
```

Look at Events. Common causes:

- No StorageClass with name `<name>` exists
- StorageClass exists but doesn't support requested access mode (e.g., asking for RWX from EBS)
- Cluster CSI driver in `openshift-cluster-csi-drivers` is degraded

### Pod stuck in `Pending` because PVC unbound

`oc describe pod <name>` shows `volume not yet bound`. Fix the PVC.

### Pod stuck in `ContainerCreating` due to mount failure

```bash
oc describe pod <name>
```

Common causes:

- SELinux context wrong on bind mount (use `:Z` if running locally)
- NFS server unreachable
- AccessMode not satisfied by underlying volume

### Filesystem full despite PVC expanded

The PVC may show new capacity but the filesystem inside the pod hasn't been resized. Restart the pod:

```bash
oc rollout restart deploy/web
```

---

## Verification

After storage changes:

- `oc get pvc` shows `Bound` status with expected size
- `oc get pv` shows the underlying PV
- `oc rsh <pod>` then `df -h /mountpoint` shows expected size
- `oc rsh <pod>` then `touch /mountpoint/test` creates a file (write works)
- After pod restart (`oc rollout restart`), the file persists (data survives)
