output "fqdn" {
  description = "Fully qualified domain name of the service"
  value       = "${var.dns_name}.${var.dns_zone_name}"
}

output "origin_ca_cert_pem" {
  value       = cloudflare_origin_ca_certificate.origin_cert.certificate
  description = "Cloudflare Origin CA Certificate"
}

output "origin_ca_key_pem" {
  value       = tls_private_key.origin_key.private_key_pem
  description = "Private key for Cloudflare Origin CA"
  sensitive   = true
}