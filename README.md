# selfhost

Infrastructure-as-code for a personal self-hosted server: a single Hetzner Cloud VM running K3s, fronted by Traefik with automated TLS and GitHub OAuth2, hosting a handful of apps deployed with FluxCD.

The repo is organized as four ordered stages, where only first two has to be executed manualle and the rest is deployed automatically via Flux:

| Stage | Tool | Purpose |
|---|---|---|
| [01-infra](01-infra/README.md) | OpenTofu (Terraform) | Provisions the Hetzner server, firewall, and Cloudflare DNS |
| [02-bootstrap](02-bootstrap/README.md) | Ansible | Configures the OS and installs the K3s cluster including Flux connection; handles OS/k3s upgrades |
| [03-platform](03-platform/README.md) | Flux | Cluster add-ons: ingress (Traefik), TLS certificates, OAuth2 etc |
| [04-deploy](04-deploy/README.md) | Flux | User-facing applications (e.g. paperless-ngx, audiobookshelf) |
