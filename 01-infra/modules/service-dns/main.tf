resource "cloudflare_record" "this" {
  for_each = var.target_ips

  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "A"
  content = each.value
  ttl     = var.proxied ? 1 : var.ttl
  proxied = var.proxied
  comment = "Managed by rootenv/infra/terraform — service ${var.dns_name} (${each.key}) — ${var.environment}"
}

resource "tls_private_key" "origin_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "origin_csr" {
  private_key_pem = tls_private_key.origin_key.private_key_pem

  subject {
    common_name  = "${var.dns_name}.${var.dns_zone_name}"
    organization = "Selfhosted Services"
  }
}

resource "cloudflare_origin_ca_certificate" "origin_cert" {
  csr                = tls_cert_request.origin_csr.cert_request_pem
  hostnames          = ["${var.dns_name}.${var.dns_zone_name}"]
  request_type       = "origin-rsa"
  requested_validity = 5475 # 15 years
}