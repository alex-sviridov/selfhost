data "sops_file" "config" {
  source_file = "./config.sops.yaml"
}

data "sops_file" "shared" {
  source_file = "../../../.sops.env"
  input_type  = "dotenv"
}

locals {
  config = yamldecode(data.sops_file.config.raw)

  ssh_public_keys  = local.config.ssh_public_keys
  allowed_ssh_ips  = local.config.allowed_ssh_ips
  dns_zone_name    = data.sops_file.shared.data["DNS_ZONE_NAME"]
  dns_zone_id      = data.sops_file.shared.data["DNS_ZONE_ID"]
  service_dns_name = data.sops_file.shared.data["SERVICE_DNS_NAME"]
}

resource "random_pet" "server_name" {
  count     = var.server_count
  length    = 1
  separator = "-"
}

module "host" {
  count           = var.server_count
  source          = "../../modules/node"
  name            = random_pet.server_name[count.index].id
  dns_name        = random_pet.server_name[count.index].id
  environment     = var.environment
  ssh_public_keys = local.ssh_public_keys
  allowed_ssh_ips = local.config.allowed_ssh_ips
  dns_zone_id     = local.dns_zone_id
  dns_zone_name   = local.dns_zone_name
  server_type     = var.server_type
  location        = var.server_location
  image           = var.server_image
}

resource "local_sensitive_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../templates/ansible-inventory.tftpl", {
    hosts = [
      for h in module.host : {
        name = h.name
        ip   = h.ipv4_address
        fqdn = h.fqdn
      }
    ]
  })
  filename = "${path.module}/../../../02-os-bootstrap/inventory.ini"
}

module "service_dns_name" {
  source        = "../../modules/dns_name"
  dns_zone_id   = local.dns_zone_id
  dns_zone_name = local.dns_zone_name
  dns_name      = local.service_dns_name
  target_ips    = { for k, v in module.host : k => v.ipv4_address }
  proxied       = true
  environment   = var.environment
}