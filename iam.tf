
resource "google_project_service" "service" {
  project               = google_project.project.project_id
  disable_on_destroy    = false

  service = each.key
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "anthosconfigmanagement.googleapis.com",
    "gkehub.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudkms.googleapis.com",
    "iam.googleapis.com"
  ])
}
