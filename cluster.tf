
resource "google_container_cluster" "cluster" {
  provider                  = google-beta
  project                   = google_project.project.project_id

  name                      = var.cluster_name
  location                  = var.region
  network                   = var.network
  subnetwork                = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    // Choose the range, but let GCP pick the IPs within the range
    cluster_secondary_range_name  = var.ip_range_pods_name
    services_secondary_range_name = var.ip_range_services_name
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  depends_on = [
    google_compute_subnetwork.vpc-subnet-us-central1,
  ]
}


resource "google_container_node_pool" "cluster-np" {
  name       = "${var.cluster_name}-custom-nodepool-1"
  cluster    = google_container_cluster.cluster.id
  node_count = 1

  node_config {
    machine_type = var.nodepool_machine_type
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    #service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  timeouts {
    create = "30m"
    update = "20m"
  }
}