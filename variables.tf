variable "project_name" {}
variable "billing_account" {}


variable "create_service_account" {
  type        = bool
  description = "Defines if service account specified to run nodes should be created."
  default     = true
}

variable "grant_registry_access" {
  type        = bool
  description = "Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles."
  //default     = false
  default     = true
}

variable "registry_project_ids" {
  type        = list(string)
  description = "Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` and `artifactregsitry.reader` roles are assigned on these projects."
  default     = []
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created."
  default     = ""
}

variable "cluster_name" {
  description = "The name of the cluster"
}

variable "nodepool_machine_type" {
  description = "The GCP VM machine type to be used in GKE NodePools."
}

variable "master_ipv4_cidr_block" {
    description = "The subnet that that the control plane operates in"
}

variable "vpc_subnet" {
    description = "The subnet that that the control plane operates in"
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "network" {
  description = "The VPC network to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
}

variable "ip_range_pods_name" {
  description = "The name of the secondary ip range to use for pods"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
}

variable "ip_range_services_name" {
  description = "The name of the secondary ip range to use for services"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
}

variable "vpc_routing_mode" {
  description = "REGIONAL or GLOBAL"
}

variable "acm_location" {
  description = "acm_location"
}

variable "acm_sync_repo" {
  description = "acm_sync_repo"
}

variable "acm_sync_branch" {
  description = "acm_sync_branch"
}

variable "acm_policy_dir" {
  description = "acm_policy_dir"
}

variable "acm_secret_type" {
  description = "acm_secret_type"
}