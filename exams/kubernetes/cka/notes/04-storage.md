# Storage

## Overview

This domain represents 10% of the CKA exam. While it is the smallest domain, storage tasks are usually straightforward if you understand the PV/PVC model and can write the YAML correctly.

**[Storage](https://kubernetes.io/docs/concepts/storage/)** - Kubernetes storage overview

## Persistent Volumes (PV)

Persistent Volumes are cluster-level storage resources provisioned by an administrator or dynamically via Storage Classes. They exist independently of any pod that uses them.

### PV Specification

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-data
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: /mnt/data
```

### Access Modes

| Mode | Abbreviation | Description |
|------|-------------|-------------|
| ReadWriteOnce | RWO | Can be mounted as read-write by a single node |
| ReadOnlyMany | ROX | Can be mounted as read-only by many nodes |
| ReadWriteMany | RWX | Can be mounted as read-write by many nodes |
| ReadWriteOncePod | RWOP | Can be mounted as read-write by a single pod (v1.29+) |

**Important:** Access modes describe the capability of the volume, not the enforced access. For example, a hostPath volume only supports RWO because it is local to a single node.

### Volume Modes

- **Filesystem** (default) - volume is mounted as a directory in the container
- **Block** - volume is presented as a raw block device (no filesystem)

### Reclaim Policies

What happens to the PV when its PVC is deleted:

- **Retain** - PV is kept with its data intact, must be manually cleaned up
- **Delete** - PV and the underlying storage resource are deleted
- **Recycle** (deprecated) - basic scrub (`rm -rf /thevolume/*`) before making available again

### PV Status Lifecycle

1. **Available** - free resource, not yet bound to a claim
2. **Bound** - volume is bound to a PVC
3. **Released** - PVC has been deleted, but the resource is not yet reclaimed
4. **Failed** - volume has failed its automatic reclamation

**[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)** - Complete PV documentation

## Persistent Volume Claims (PVC)

PVCs are requests for storage by users. They consume PV resources similar to how pods consume node resources.

### PVC Specification

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: manual
```

### PV-PVC Binding

A PVC binds to a PV based on:
1. **Access mode** - must match
2. **Storage size** - PV must have capacity >= PVC request
3. **Storage class** - must match (empty string means no class)
4. **Label selector** - optional, further constrains binding

If multiple PVs satisfy a PVC, Kubernetes picks the one with the smallest capacity that still meets the request.

```yaml
# PVC with label selector
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-specific
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  selector:
    matchLabels:
      environment: production
```

### Using PVCs in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-storage
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data-volume
      mountPath: /usr/share/nginx/html
  volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: pvc-data
```

**[Persistent Volume Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)** - PVC documentation
**[Configure a Pod to Use a PersistentVolume](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)** - PV/PVC tutorial

## Storage Classes

Storage Classes enable dynamic provisioning of Persistent Volumes. When a PVC requests a Storage Class, the provisioner automatically creates a PV.

### Storage Class Definition

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/no-provisioner  # For local/hostPath
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

### Common Provisioners

| Provisioner | Description |
|------------|-------------|
| `kubernetes.io/aws-ebs` | AWS Elastic Block Store |
| `kubernetes.io/gce-pd` | GCE Persistent Disk |
| `kubernetes.io/azure-disk` | Azure Managed Disk |
| `kubernetes.io/no-provisioner` | No dynamic provisioning (local volumes) |

### Volume Binding Modes

- **Immediate** (default) - PV is provisioned as soon as PVC is created
- **WaitForFirstConsumer** - PV provisioning is delayed until a pod using the PVC is scheduled. This ensures the PV is created in the same topology zone as the pod.

### Dynamic Provisioning Flow

1. Administrator creates a StorageClass
2. User creates a PVC referencing the StorageClass
3. The provisioner automatically creates a PV matching the PVC
4. The PVC binds to the new PV
5. Pod mounts the PVC

```yaml
# PVC using dynamic provisioning
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: fast-storage
  resources:
    requests:
      storage: 20Gi
```

### Default Storage Class

When a PVC does not specify a `storageClassName`, the default Storage Class is used.

```bash
# Check default storage class
kubectl get sc

# Set a storage class as default
kubectl annotate storageclass fast-storage \
  storageclass.kubernetes.io/is-default-class=true

# Remove default annotation from another class
kubectl annotate storageclass old-default \
  storageclass.kubernetes.io/is-default-class-
```

**[Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)** - StorageClass documentation
**[Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/)** - Dynamic provisioning guide
**[Change Default StorageClass](https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/)** - Managing default class

## Volume Types

### emptyDir

Temporary storage that exists for the lifetime of the pod. Deleted when the pod is removed.

```yaml
spec:
  containers:
  - name: app
    volumeMounts:
    - name: cache
      mountPath: /cache
  volumes:
  - name: cache
    emptyDir:
      sizeLimit: 500Mi
```

**Use Cases:**
- Scratch space for temporary data
- Sharing files between containers in a multi-container pod
- Cache storage

### hostPath

Mounts a file or directory from the host node's filesystem into the pod.

```yaml
spec:
  containers:
  - name: app
    volumeMounts:
    - name: host-data
      mountPath: /data
  volumes:
  - name: host-data
    hostPath:
      path: /var/data
      type: DirectoryOrCreate
```

**hostPath Types:**
- `""` (empty) - no checks
- `DirectoryOrCreate` - create directory if it does not exist
- `Directory` - directory must exist
- `FileOrCreate` - create file if it does not exist
- `File` - file must exist

**Warning:** hostPath volumes are a security risk in production. They give pods access to the host filesystem. Use with caution and prefer PVCs instead.

### configMap Volume

Mounts ConfigMap data as files in a container.

```yaml
spec:
  containers:
  - name: app
    volumeMounts:
    - name: config
      mountPath: /etc/config
  volumes:
  - name: config
    configMap:
      name: app-config
      items:          # Optional: mount specific keys
      - key: config.yaml
        path: app-config.yaml
```

### secret Volume

Mounts Secret data as files in a container. Files are base64-decoded.

```yaml
spec:
  containers:
  - name: app
    volumeMounts:
    - name: certs
      mountPath: /etc/certs
      readOnly: true
  volumes:
  - name: certs
    secret:
      secretName: tls-certs
```

**[Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)** - All volume types
**[Projected Volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/)** - Combining sources

## Volume Expansion

Storage Classes with `allowVolumeExpansion: true` allow PVCs to be resized.

```bash
# Edit the PVC to increase storage
kubectl edit pvc my-pvc
# Change spec.resources.requests.storage to a larger value

# Or patch it
kubectl patch pvc my-pvc -p '{"spec":{"resources":{"requests":{"storage":"20Gi"}}}}'
```

**Note:** You can only expand volumes, never shrink them. Some volume types require the pod to be restarted for the filesystem to be resized.

**[Expanding Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#expanding-persistent-volumes-claims)** - Volume expansion

## Complete PV/PVC Example

Here is a complete example creating a PV, PVC, and pod that uses it:

```yaml
# 1. Create the Persistent Volume
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: /mnt/data
---
# 2. Create the Persistent Volume Claim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pvc
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
---
# 3. Create a Pod using the PVC
apiVersion: v1
kind: Pod
metadata:
  name: task-pod
spec:
  containers:
  - name: task-container
    image: nginx
    volumeMounts:
    - name: task-storage
      mountPath: /usr/share/nginx/html
  volumes:
  - name: task-storage
    persistentVolumeClaim:
      claimName: task-pvc
```

## Key Exam Tips for This Domain

1. **PV/PVC binding** - access mode and storage class must match; PV capacity must be >= PVC request
2. **Know the three reclaim policies** - Retain, Delete, Recycle (deprecated)
3. **storageClassName must match exactly** between PV and PVC (including empty string vs no field)
4. **hostPath is commonly used in exam environments** since there is no cloud provisioner
5. **Practice writing PV, PVC, and Pod YAML from scratch** - you will need to do this quickly
6. **WaitForFirstConsumer** binding mode is important for topology-aware provisioning
7. **Volume mounts go in the container spec**, volumes go in the pod spec - do not confuse them
