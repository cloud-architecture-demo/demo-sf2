
resource "google_gke_hub_membership" "membership" {
    provider                = google-beta

    project                 = google_project.project.project_id
    membership_id           = "${var.cluster_name}-membership"
    endpoint {
        gke_cluster {
            resource_link   = "//container.googleapis.com/${google_container_cluster.cluster.id}"
        }
    }
}

resource "google_gke_hub_feature" "feature" {
  provider    = google-beta

  project     = google_project.project.project_id
  name        = "configmanagement"
  location    = var.acm_location

  depends_on = [
    google_project_service.service,
  ]
}

resource "google_gke_hub_feature_membership" "feature_member" {
  provider      = google-beta

  project       = google_project.project.project_id
  location      = var.acm_location
  feature       = google_gke_hub_feature.feature.name
  membership    = google_gke_hub_membership.membership.membership_id

  configmanagement {
    version = "1.15.2"
    config_sync {
      source_format = "hierarchy"
      //source_format = "unstructured"
      git {
        sync_repo     = var.acm_sync_repo
        sync_branch   = var.acm_sync_branch
        policy_dir    = var.acm_policy_dir
        secret_type   = var.acm_secret_type
      }
    }

    policy_controller {
      audit_interval_seconds        = "15"
      enabled                       = true
      template_library_installed    = true
    }
  }

  depends_on = [
    google_project_service.service,
  ]
}

