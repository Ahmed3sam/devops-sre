output "kubernetes_cluster_name" {
  value = module.gke.kubernetes_cluster_name
}


output "kubernetes_cluster_host" {
  value = module.gke.kubernetes_cluster_host
}

output "registry_url" {
  value = module.registry.registry_url
}