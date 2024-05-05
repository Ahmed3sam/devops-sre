locals {
  hostname = format("%s-bastion", var.bastion_name)
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:${var.service_account}"
}


// Allow access to the Bastion Host via SSH.
resource "google_compute_firewall" "bastion-ssh" {
  name      = format("%s-bastion-ssh", var.bastion_name)
  network   = var.network_name
  direction = "INGRESS"
  project   = var.project_id


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["bastion"]
}


// The Bastion host.
resource "google_compute_instance" "bastion" {
  name         = local.hostname
  machine_type = "e2-micro"
  zone         = var.zone
  project      = var.project_id
  tags         = ["bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }


  network_interface {
    subnetwork = var.subnet_name
    network_ip = var.internal_ip
  }

  // Allow the instance to be stopped by Terraform when updating configuration.
  allow_stopping_for_update = true

  scheduling {
    preemptible       = true
    automatic_restart = false
  }
}