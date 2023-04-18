data "google_client_config" "default" {
  depends_on = [google_container_cluster.cluster]
}

data "google_container_cluster" "default" {
  name       = google_container_cluster.cluster.name
  location   = var.region
  depends_on = [google_container_cluster.cluster]
}

#---------------------------------------------------------------
# Providers
#---------------------------------------------------------------

provider "kubectl" {
  apply_retry_count = 10
  host              = "https://${data.google_container_cluster.default.endpoint}"
  token             = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.default.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
    )
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
