# Infrastructure Provisioning

Provisions core compute, networking, and security resources using Terraform.

```bash
cd environments/prod/
cp terraform.tfvars.exampe terraform.tfvarfs
vi terraform.tfvarfs
# add data
tofu init
tofu plan
tofu apply
```