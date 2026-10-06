# Infrastructure Provisioning

Provisions core compute, networking, and security resources using Terraform.

## Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/)
  
## SOPS data required

- ../.sops.env
    - **DNS_ZONE_NAME**: Base domain name managed in Cloudflare (e.g., example.com).
    - **SERVICE_DNS_NAME**: Subdomain prefix used for the cluster or host routing.
    - **DNS_ZONE_ID**: Unique zone identifier in Cloudflare corresponding to the target domain.

- environments/prod/secrets.sops.yaml
    - **hcloud_api_token**: API token used to authenticate with Hetzner Cloud for infrastructure provisioning.
    - **cloudflare_api_token**: API token used authenficate with Cloudflare for DNS updates.

- environments/prod/config.sops.yaml
    - **ssh_public_keys**: List of public SSH keys installed on provisioned instances for administrative access.
    - **allowed_ssh_ips**: List of IP CIDR blocks permitted to connect via SSH in firewall rules.

## How to

```bash
cd environments/prod/
tofu init
tofu plan
tofu apply
```