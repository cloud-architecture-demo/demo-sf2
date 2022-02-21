
/*
resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}
*/

resource "google_service_account" "cluster_service_account" {
  project      = google_project.project.project_id
  //account_id   = "tf-gke-${substr(var.cluster_name, 0, min(15, length(var.cluster_name)))}-${random_string.cluster_service_account_suffix.result}"
  account_id   = "tf-gke-${substr(var.cluster_name, 0, min(15, length(var.cluster_name)))}"
  display_name = "Terraform-managed service account for cluster ${var.cluster_name}"
}

resource "google_service_account_key" "jenkins" {
  service_account_id = google_service_account.cluster_service_account.id
  //service_account_id = google_service_account.cluster_service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "local_file" "service_account" {
    content  = base64decode(google_service_account_key.jenkins.private_key)
    filename = "./apps/_credentials/serviceaccount.json"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  project  = google_project.project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-metric_writer" {
  project  = google_project.project.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-monitoring_viewer" {
  project  = google_project.project.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-resourceMetadata-writer" {
  project  = google_project.project.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  project  = google_project.project.project_id
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-artifact-registry" {
  project  = google_project.project.project_id
  role     = "roles/artifactregistry.reader"
  member   = "serviceAccount:${google_service_account.cluster_service_account.email}"
}
