variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "ssh_public_keys" {
  description = "SSH public keys for admin access to the node"
  type        = list(string)
}

variable "ssh_private_key_path" {
  description = "SSH private keys for admin access to the node, used to retrieve kubeconfig"
  type        = string
}

variable "allowed_ssh_ips" {
  description = "CIDRs allowed to reach SSH and Kubernetes API"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "environment" {
  description = "Environment name (sandbox/prod)"
  type        = string
  default     = "prod"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token (Zone:DNS:Edit,Zone:SSL and Certificates:Edit)"
  type        = string
  sensitive   = true
}

variable "dns_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "dns_zone_name" {
  description = "DNS zone name for infrastructure records"
  type        = string
}

variable "server_count" {
  type        = number
  default     = 1
  description = "Count of servers to create"
}

variable "service_dns_name" {
  description = "DNS name for the rootenv service, relative to dns_zone_name (e.g. 'selfhost' → selfhost.example.com)"
  type        = string
  default     = "sandbox"
}

variable "server_type" {
  description = "Hetzner server type"
  type        = string
  default     = "cx23"
}

variable "server_location" {
  description = "Hetzner datacenter location"
  type        = string
  default     = "nbg1"
}

variable "server_image" {
  description = "Base OS image"
  type        = string
  default     = "rocky-10"
}