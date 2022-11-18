data "google_project" "project" {}

data "google_client_config" "default" {}

data "kubernetes_service" "airflow-webserver" {
  metadata {
    name = "airflow-webserver"
    namespace = "airflow"
  }

  depends_on = [
    helm_release.airflow
  ]
}

