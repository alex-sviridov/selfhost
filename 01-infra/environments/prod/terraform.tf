terraform {
  required_version = ">= 1.2"

  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "~> 1.4"
    }

    tailscale = {
      source = "tailscale/tailscale"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.40"
    }

  }
}

ephemeral "sops_file" "secrets" {
  source_file = "./secrets.sops.yaml"
}

provider "hcloud" {
  token = ephemeral.sops_file.secrets.data["hcloud_api_token"]
}


provider "cloudflare" {
  api_token = ephemeral.sops_file.secrets.data["cloudflare_api_token"]
}

provider "tailscale" {
  api_key = ephemeral.sops_file.secrets.data["tailscale_api_token"]
}