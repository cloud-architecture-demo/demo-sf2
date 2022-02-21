resource "google_compute_network" "vpc-net" {
  project                           = google_project.project.project_id
  name                              = var.network
  auto_create_subnetworks           = false
  delete_default_routes_on_create   = false
  description                       = "Compute Network for GKE nodes"
  routing_mode                      = var.vpc_routing_mode

  depends_on = [
    google_project_service.service,
  ]
}

resource "google_compute_subnetwork" "vpc-subnet-us-central1" {
  project                   = google_project.project.project_id
  name                      = var.subnetwork
  ip_cidr_range             = var.vpc_subnet
  region                    = var.region
  private_ip_google_access  = true
  network                   = google_compute_network.vpc-net.id

  secondary_ip_range {
    range_name    = var.ip_range_pods_name
    ip_cidr_range = var.ip_range_pods
  }
  secondary_ip_range {
    range_name    = var.ip_range_services_name
    ip_cidr_range = var.ip_range_services
  }
}

resource "google_compute_router" "router" {
  project   = google_project.project.project_id
  name      = "${var.project_name}-router"
  region    = var.region
  network   = google_compute_network.vpc-net.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project                               = google_project.project.project_id
  name                                  = "${var.project_name}-router-nat"
  router                                = google_compute_router.router.name
  region                                = var.region
  nat_ip_allocate_option                = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat    = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

