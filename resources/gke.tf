module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version = "23.3.0"
  project_id                 = data.google_project.project.project_id
  name                       = var.cluter_name
  region                     = var.region
  regional                   = true
  zones                      = var.availability_zones
  network                    = module.gcp-network.network_name
  subnetwork                 = module.gcp-network.subnets_names[0]
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  remove_default_node_pool   = true


  node_pools                 = local.node_pools

  node_pools_oauth_scopes    = local.node_pools_oauth_scopes
}
