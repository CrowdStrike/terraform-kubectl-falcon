output "kubernetes_cluster_host" {
  value       = google_container_cluster.cluster.endpoint
  description = "GKE Cluster Host that was created"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.cluster.name
  description = "GKE Cluster Name that was created"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project"
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "kubernetes_get_credentials_command" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.cluster.name} --region ${var.region} --project ${var.project_id}"
  description = "GCloud update kubeconfig command"
}
