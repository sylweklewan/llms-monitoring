terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.1"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kubernetes_api_config
  config_context = "default"
}

provider "null" {}

provider "local" {}