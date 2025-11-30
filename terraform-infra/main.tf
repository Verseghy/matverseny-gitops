terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com"
    }

    bucket = "matverseny-195"
    key = "terraform-infra/main.tfstate"

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
  }
}

provider "digitalocean" {
}

data "digitalocean_kubernetes_versions" "v1_34" {
  version_prefix = "1.34."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name = "matverseny-production"
  region  = "fra1"
  version = data.digitalocean_kubernetes_versions.v1_34.latest_version

  ha = var.stage == "BOOTSTRAP" ? false : true
  destroy_all_associated_resources = true

  maintenance_policy {
    start_time = "04:00"
    day = "sunday"
  }

  node_pool {
    name = "default"
    size = var.stage == "BOOTSTRAP" ? "s-1vcpu-2gb" : "s-4vcpu-8gb"
    node_count = 3
  }
}

