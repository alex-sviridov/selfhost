# How-to restore a namespace

- Remove a namespace

```bash
k delete ns audiobookshelf
```

- Nudge flux to reconcile

```bash
flux reconcile kustomization selfhost --with-source
``` 

- Pause reconciliation

```bash
flux suspend kustomization selfhost
```

- Stop deployment and remove pvcs

```bash
kubectl scale deployment/audiobookshelf --replicas=0 -n audiobookshelf
kubectl delete pvc -l app.kubernetes.io/name=audiobookshelf -n audiobookshelf
```

- Restore PVCs

```bash
velero restore create restore-$(date +"%d-%m-%y") \
  --from-backup daily-20261006051111 \
--include-resources persistentvolumeclaims,persistentvolumes,pods \
  --include-namespaces audiobookshelf 
```