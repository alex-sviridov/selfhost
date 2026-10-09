#!/bin/bash

kubectl -n flux-system get gitrepositories,kustomizations

kubectl -n flux-system annotate --overwrite gitrepository/selfhost \
    reconcile.fluxcd.io/requestedAt="$(date +%s)"
sleep 5
kubectl -n flux-system get gitrepositories,kustomizations