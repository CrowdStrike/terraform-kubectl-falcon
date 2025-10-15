terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.2.1"
    }
  }
}
