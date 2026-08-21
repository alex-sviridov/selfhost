module "host" {
  for_each = var.servers
  source          = "../../modules/node"
  name            = each.key
  dns_name        = each.key
  environment     = var.environment
  ssh_public_keys = var.ssh_public_keys
  allowed_ssh_ips = var.allowed_ssh_ips
  dns_zone_id     = var.dns_zone_id
  dns_zone_name   = var.dns_zone_name
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../templates/ansible-inventory.tftpl", {
    hosts = module.host
  })
  filename = "${path.module}/../../../02-os-bootstrap/inventory.ini"
}

module "service_dns" {
  source = "../../modules/service-dns"

  dns_zone_id   = var.dns_zone_id
  dns_zone_name = var.dns_zone_name
  dns_name      = var.service_dns_name
  target_ips    = { for k, v in module.host : k => v.ipv4_address }
  proxied       = true
  environment   = var.environment
}

resource "local_file" "origin_ca_cert_pem" {
  content = module.service_dns.origin_ca_cert_pem
  filename = "${path.module}/../../../03-platform/files/cloudflare.crt"
}

resource "local_file" "private_key_pem" {
  content = module.service_dns.private_key_pem
  filename = "${path.module}/../../../03-platform/files/cloudflare.key"
}