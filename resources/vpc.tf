module "gcp-network" {
  source           = "terraform-google-modules/network/google"
  version          = ">= 4.0.1"

  project_id       = var.project_id
  network_name     = var.network

  subnets          = local.vpc_subnets

  secondary_ranges = local.gke_subnet_ranges
}
