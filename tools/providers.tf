terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50, < 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
  backend "gcs" {
    bucket = "terraform-bucket-state-sample"
    prefix = "terraform/tools"
  }
}


provider "google" {
  region  = var.region
  project = var.project_id
  credentials = var.credentials_file_path
}

data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = "app-cluster"
  location = var.main_zone
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  }
}


