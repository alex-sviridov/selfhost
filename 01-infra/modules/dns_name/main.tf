resource "cloudflare_record" "this" {
  for_each = var.target_ips

  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "A"
  content = each.value
  ttl     = var.proxied ? 1 : var.ttl
  proxied = var.proxied
  comment = "Managed by terraform — service ${var.dns_name} (${each.key}) — ${var.environment}"
}