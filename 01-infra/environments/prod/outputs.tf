output "node_fqdns" {
  description = "Map of node names to their DNS names"
  value       = { for k, v in module.host : k => v.fqdn }
}

output "node_ipv4s" {
  description = "Map of node names to Public IPv4 addresses"
  value       = { for k, v in module.host : k => v.ipv4_address }
}

output "service_fqdn" {
  description = "Public FQDN of the rootenv service"
  value       = module.service_dns.fqdn
}

output "origin_ca_cert_pem" {
  value       = module.service_dns.origin_ca_cert_pem
  description = "Cloudflare Origin CA Certificate"
  sensitive   = true
}

output "origin_ca_key_pem" {
  value       = module.service_dns.origin_ca_key_pem
  description = "Private key for Cloudflare Origin CA"
  sensitive   = true
}