# Applications Deployment

Deploys user-facing applications via Helm and Kustomize.

## Prerequisites

- [helm](https://helm.sh/docs/intro/install/)
- [helmfile](https://helmfile.readthedocs.io/en/latest/#installation)

## Environment variables required

- **SERVICE_HOSTNAME**: web service FQDN

## Run

```bash
source ../.env
helmfile init --force
helmfile apply
```