
resource "google_artifact_registry_repository" "repo" {
    project               = google_project.project.project_id

    provider              = google-beta

    location              = "us-central1"
    repository_id         = "sock-shop-build"
    description           = "Sock Shop container images - CICD"
    format                = "DOCKER"
    //kms_key_name          = data.google_kms_crypto_key.crypto_key.name

  depends_on = [
    google_project_service.service,
  ]
}
