
## Obtain the GKE cluster authentication token and store it as an object.
data "google_client_config" "provider" {
  depends_on = [
    google_container_cluster.cluster,
  ]
}

data "google_container_cluster" "cluster" {
  project     = google_project.project.project_id

  name        = var.cluster_name
  location    = var.region

  depends_on = [
    google_container_cluster.cluster,
  ]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,)
}

provider "kubectl" {
  host                      = "https://${google_container_cluster.cluster.endpoint}"
  //host                      = data.google_container_cluster.cluster.endpoint
  //cluster_ca_certificate    = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,)
  cluster_ca_certificate    = base64decode(data.google_container_cluster.cluster.master_auth[0].cluster_ca_certificate,)
  token                     = data.google_client_config.provider.access_token
  load_config_file          = false
  apply_retry_count      = "4"
}

data "kubectl_file_documents" "jenkins_operator_manifests" {
    content = file("./apps/jenkins-operator/jenkins-operator.yaml")
}

resource "kubectl_manifest" "jenkins_operator" {
    count     = length(data.kubectl_file_documents.jenkins_operator_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.jenkins_operator_manifests.documents, count.index)

    depends_on = [
    google_container_cluster.cluster,
  ]
}

data "kubectl_file_documents" "jenkins_server_manifests" {
    content = file("./apps/jenkins-server/jenkins-server.yaml")
}

resource "kubectl_manifest" "jenkins_server" {
    count     = length(data.kubectl_file_documents.jenkins_server_manifests.documents)
    yaml_body = element(data.kubectl_file_documents.jenkins_server_manifests.documents, count.index)

  depends_on = [
    google_container_cluster.cluster,
  ]
}
