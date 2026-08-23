# Platform Services Deployment

Deploys foundational cluster add-ons via Helm, configuring ingress routing (Traefik), automated TLS certificates, and OAuth2 authentication.

## Prerequisites

- [helm](https://helm.sh/docs/intro/install/)
- [helmfile](https://helmfile.readthedocs.io/en/latest/#installation)

## Run

```bash
set -o allexport && source .env && set +o allexport
helmfile init --force
helmfile apply
```