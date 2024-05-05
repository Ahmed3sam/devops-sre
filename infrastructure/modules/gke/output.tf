output "kubernetes_cluster_host" {
  value       = google_container_cluster.app_cluster.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.app_cluster.name
  description = "GKE Cluster Name"
}