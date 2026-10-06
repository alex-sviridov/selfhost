variable "environment" {
  description = "Environment name (sandbox/prod)"
  type        = string
  default     = "prod"
}

variable "server_count" {
  type        = number
  default     = 1
  description = "Count of servers to create"
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