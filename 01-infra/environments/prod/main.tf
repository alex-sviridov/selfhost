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
  
  cloudflare_ips = concat(
    data.cloudflare_ip_ranges.cf.ipv4_cidr_blocks,
    data.cloudflare_ip_ranges.cf.ipv6_cidr_blocks,
  )
}

resource "random_pet" "server_name" {
  count     = length(var.nodes)
  length    = 1
  separator = "-"
}

resource "hcloud_ssh_key" "admin" {
  count      = length(local.ssh_public_keys)
  name       = "${var.environment}-admin-${count.index}"
  public_key = local.ssh_public_keys[count.index]
}

resource "tailscale_tailnet_key" "node" {
  count         = length(var.nodes)
  reusable      = false 
  preauthorized = true
  ephemeral     = false
  expiry        = 3600  
  tags          = ["tag:server"]
}

resource "hcloud_network" "cluster" {
  name     = "${var.environment}-cluster"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "nodes" {
  network_id   = hcloud_network.cluster.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

data "cloudflare_ip_ranges" "cf" {}

resource "hcloud_firewall" "nodes" {
  name = "${var.environment}-nodes"

  # HTTP/HTTPS only from Cloudflare
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = local.cloudflare_ips
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = local.cloudflare_ips
  }

  apply_to {
    label_selector = "project=selfhost,env=${var.environment}"
  }
}

module "host" {
  count           = length(var.nodes)
  source          = "../../modules/node"
  name            = random_pet.server_name[count.index].id
  dns_name        = random_pet.server_name[count.index].id
  environment     = var.environment
  ssh_public_keys = local.ssh_public_keys
  ssh_key_ids     = hcloud_ssh_key.admin[*].id
  network_id      = hcloud_network_subnet.nodes.network_id
  tailscale_auth_key = tailscale_tailnet_key.node[count.index].key
  dns_zone_id     = local.dns_zone_id
  dns_zone_name   = local.dns_zone_name
  server_type     = var.nodes[count.index].server_type
  location        = var.nodes[count.index].location
  image           = var.server_image
}

resource "local_sensitive_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../templates/ansible-inventory.tftpl", {
    hosts = [
      for i, h in module.host : {
        name = h.name
        ip   = h.ipv4_address
        fqdn = h.fqdn
        role = var.nodes[i].role
        private_ip = h.private_ip
      }
    ]
  })
  filename = "${path.module}/../../../02-bootstrap/inventory.ini"
}

module "service_dns_name" {
  source        = "../../modules/dns_name"
  dns_zone_id   = local.dns_zone_id
  dns_zone_name = local.dns_zone_name
  dns_name      = local.service_dns_name
  target_ips = { for i, h in module.host : i => h.ipv4_address if var.nodes[i].role == "agent" }
  proxied       = true
  environment   = var.environment
}