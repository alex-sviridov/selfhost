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
  ssh_public_keys = var.ssh_public_keys
  allowed_ssh_ips = var.allowed_ssh_ips
  dns_zone_id     = var.dns_zone_id
  dns_zone_name   = var.dns_zone_name
  server_type     = var.server_type
  location        = var.server_location
  image           = var.server_image
}

resource "local_file" "ansible_inventory" {
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
  create_certs  = true
  dns_zone_id   = var.dns_zone_id
  dns_zone_name = var.dns_zone_name
  dns_name      = var.service_dns_name
  target_ips    = { for k, v in module.host : k => v.ipv4_address }
  proxied       = true
  environment   = var.environment
}

resource "local_file" "origin_ca_cert_pem" {
  content = module.service_dns_name.origin_ca_cert_pem
  filename = "${path.module}/../../../03-platform/files/cloudflare.crt"
}

resource "local_file" "private_key_pem" {
  content = module.service_dns_name.private_key_pem
  filename = "${path.module}/../../../03-platform/files/cloudflare.key"
}