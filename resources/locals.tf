locals {
  vpc_subnets = [
    {
      subnet_name   = var.subnetwork
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  gke_subnet_ranges = {
    (var.subnetwork) = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }

  node_pools = [for k,v in var.availability_zones : {
    name                      = "node-pool-${k}"
    machine_type              = "e2-standard-2"
    node_locations            = v
    autoscaling               = false
    min_count                 = 1
    max_count                 = 1
    service_account           = ""
    initial_node_count        = 1
  }]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

}
