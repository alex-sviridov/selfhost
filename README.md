# selfhost

Infrastructure-as-code for a personal self-hosted server: a single Hetzner Cloud VM running K3s, fronted by Traefik with automated TLS and GitHub OAuth2, hosting a handful of apps deployed via Helm.

The repo is organized as four ordered stages, each with its own README covering prerequisites, required environment variables, and exact commands:

| Stage | Tool | Purpose |
|---|---|---|
| [01-infra](01-infra/README.md) | OpenTofu (Terraform) | Provisions the Hetzner server, firewall, and Cloudflare DNS |
| [02-os-bootstrap](02-os-bootstrap/README.md) | Ansible | Configures the OS and installs the K3s cluster; handles OS/k3s upgrades |
| [03-platform](03-platform/README.md) | Helm / helmfile | Cluster add-ons: ingress (Traefik), TLS certificates, OAuth2 |
| [04-deploy](04-deploy/README.md) | Helm / helmfile | User-facing applications (e.g. paperless-ngx, audiobookshelf) |

## Usage

1. Copy `.env.example` to `.env` and fill in your Cloudflare/Hetzner tokens,
   DNS names, SSH keys, and OAuth2 app credentials.
2. Work through the stages in order (`01-infra` → `02-os-bootstrap` →
   `03-platform` → `04-deploy`), following each stage's README.

Each stage sources the shared `.env` and expects the previous stage to have
completed successfully (e.g. `02-os-bootstrap` needs the server from
`01-infra`; `04-deploy` needs the ingress/TLS/auth stack from `03-platform`).
