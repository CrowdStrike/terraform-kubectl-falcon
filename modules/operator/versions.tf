terraform {
  required_version = ">= 1.0.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.2.1"
    }
  }
}
