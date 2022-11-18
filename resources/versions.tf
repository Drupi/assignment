terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.43.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.15.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "kubernetes" {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}
