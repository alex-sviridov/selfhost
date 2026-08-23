# Infrastructure Provisioning

Provisions core compute, networking, and security resources using Terraform.

## Prerequisites

- [OpenTofu](https://opentofu.org/docs/intro/install/)
  
## Environment variables required

- **TF_VAR_cloudflare_api_token**: API token used to authenticate with Cloudflare for managing DNS records.
- **TF_VAR_dns_zone_name**: Base domain name managed in Cloudflare (e.g., example.com).
- **TF_VAR_service_dns_name**: Subdomain prefix used for the cluster or host routing.
- **TF_VAR_dns_zone_id**: Unique zone identifier in Cloudflare corresponding to the target domain.
- **TF_VAR_hcloud_token**: API token used to authenticate with Hetzner Cloud for infrastructure provisioning.
- **TF_VAR_servers_count**: Number of server instances to provision in Hetzner Cloud.
- **TF_VAR_server_type**: Hetzner Cloud server instance type specifying CPU, RAM, and disk resources.
- **TF_VAR_server_location**: Hetzner Cloud datacenter location code where servers will be provisioned.
- **TF_VAR_server_image**: Operating system image applied to provisioned servers.
- **TF_VAR_ssh_public_keys**: List of public SSH keys installed on provisioned instances for administrative access.
- **TF_VAR_allowed_ssh_ips**: List of IP CIDR blocks permitted to connect via SSH in firewall rules.

## How to

```bash
set -o allexport && source ../.env && set +o allexport
cd environments/prod/
# add data
tofu init
tofu plan
tofu apply
```