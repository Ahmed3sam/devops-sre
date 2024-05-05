# network
module "google_networks" {
  source = "./modules/networks"

  project_id = var.project_id
  region     = var.region
}

# gke cluster
module "gke" {
  source = "./modules/gke"

  project_id                 = var.project_id
  region                     = var.main_zone
  node_zones                 = var.cluster_node_zones
  service_account            = var.service_account
  network_name               = module.google_networks.network.name
  subnet_name                = module.google_networks.subnet.name
  master_ipv4_cidr_block     = module.google_networks.cluster_master_ip_cidr_range
  pods_ipv4_cidr_block       = module.google_networks.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block   = module.google_networks.cluster_services_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32"
}

# jump host
module "bastion" {
  source = "./modules/bastion"

  project_id      = var.project_id
  region          = var.region
  zone            = var.main_zone
  bastion_name    = "app-cluster"
  network_name    = module.google_networks.network.name
  subnet_name     = module.google_networks.subnet.name
  service_account = var.service_account
  internal_ip     = module.google_networks.jump_host_ip
}

# artifact registry
module "registry" {
  source     = "./modules/artifact_registry"
  region     = var.region
  suffix     = "sample-app"
  project_id = var.project_id
}