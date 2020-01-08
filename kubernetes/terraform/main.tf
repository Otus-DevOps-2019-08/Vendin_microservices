
locals {
  cluster_type = "node-pool"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 1.4.0"
  project_id   = var.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name   = var.subnetwork
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.52.0.0/14"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.56.0.0/20"
      },
    ]
  }
}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google"
  version                  = "5.1.1"
  project_id               = var.project_id
  name                     = "${local.cluster_type}-${random_string.suffix.result}"
  regional                 = true
  region                   = var.region
  zones                    = var.zones
  kubernetes_version       = "1.14.8-gke.17"
  network                  = module.gcp-network.network_name
  subnetwork               = module.gcp-network.subnets_names[0]
  ip_range_pods            = var.ip_range_pods_name
  ip_range_services        = var.ip_range_services_name
  create_service_account   = false
  remove_default_node_pool = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "g1-small"
      min_count          = 1
      max_count          = 3
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      image_type         = "COS"
      version            = "1.14.8-gke.17"
      auto_repair        = true
      auto_upgrade       = false
      service_account    = var.compute_engine_service_account
      preemptible        = false
      initial_node_count = 1
    },
  ]
}

data "google_client_config" "default" {
}
