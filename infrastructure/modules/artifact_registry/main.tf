resource "google_artifact_registry_repository" "main" {
  location      = var.region
  repository_id = "${var.project_id}-${var.suffix}"
  description   = "${var.project_id}-${var.suffix}"
  format        = "DOCKER"
}