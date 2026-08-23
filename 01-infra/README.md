# Infrastructure Provisioning

Provisions core compute, networking, and security resources using Terraform.

```bash
set -o allexport && source ../.env && set +o allexport
cd environments/prod/
# add data
tofu init
tofu plan
tofu apply
```