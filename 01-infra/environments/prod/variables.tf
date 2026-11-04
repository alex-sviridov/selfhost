variable "environment" {
  description = "Environment name (sandbox/prod)"
  type        = string
  default     = "prod"
}

variable "nodes" {
  type = list(object({
    role        = string 
    location    = string
    server_type = string
  }))
}

variable "server_image" {
  description = "Base OS image"
  type        = string
  default     = "rocky-10"
}