#---------------------------------------------------------------
# GKE Cluster
#---------------------------------------------------------------

resource "google_container_cluster" "cluster" {
  name     = "${var.project_id}-falcon-example-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "nodes" {
  name       = google_container_cluster.cluster.name
  location   = var.region
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]

    image_type   = var.image_type
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-falcon-example-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    precondition {
      condition     = var.image_type == "COS_CONTAINERD" ? var.sensor_type == "FalconContainer" : true
      error_message = "sensor_type must be FalconContainer if node_os is COS_CONTAINERD."
    }
  }
}

#---------------------------------------------------------------
# CrowdStrike Falcon
#---------------------------------------------------------------

module "crowdstrike_falcon" {
  source  = "CrowdStrike/falcon/kubectl"
  version = "0.2.0"

  cid              = var.cid
  client_id        = var.client_id
  client_secret    = var.client_secret
  cloud            = var.cloud
  cluster_name     = google_container_cluster.cluster.name
  docker_api_token = var.docker_api_token
  sensor_type      = var.sensor_type
  operator_version = var.operator_version
}

#---------------------------------------------------------------
# VPC Resources
#---------------------------------------------------------------

resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-falcon-example-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-falcon-example-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}
