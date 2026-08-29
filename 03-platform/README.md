# Platform Services Deployment

Deploys foundational cluster add-ons via Helm, configuring ingress routing (Traefik), automated TLS certificates, and OAuth2 authentication.

## Prerequisites

- [helm](https://helm.sh/docs/intro/install/)
- [helmfile](https://helmfile.readthedocs.io/en/latest/#installation)
- [Configure](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps) GitHub OAUTH2

## Environment variables required

- **SERVICE_HOSTNAME**: web service FQDN
- **OAUTH2_CLIENT_ID**: github oauth2 details 
- **OAUTH2_CLIENT_SECRET**: github oauth2 details
- **OAUTH2_COOKIE_SECRET**: github oauth2 details
- **OAUTH2_GITHUB_USERS**: github oauth2 details

## Run

```bash
set -o allexport && source ../.env && set +o allexport
helmfile init --force
helmfile apply
```