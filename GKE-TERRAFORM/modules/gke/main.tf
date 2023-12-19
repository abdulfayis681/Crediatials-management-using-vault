# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  name                     = var.clustername
  project                  = var.projectid
  location                 = "${var.region}-a"
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = var.initial_node_count
  network                  = var.network
  subnetwork               = var.subnetwork
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  networking_mode          = var.networking_mode

  # Optional, if you want multi-zonal cluster
  #node_locations = [
  #  "${var.region}-b"
  #]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = var.channel
  }

  workload_identity_config {
    workload_pool = "${var.projectid}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  node_config {
    workload_metadata_config {
      mode = var.mode
    }
  }

 
}

resource "google_service_account" "kubernetes" {
  account_id = var.account_id
  project    = var.projectid
}

resource "google_container_node_pool" "general" {
  name       = "${var.clustername}-general"
  cluster    = google_container_cluster.primary.id
  node_count = var.nodecount

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = var.machinetype
    image_type   = var.imagetype
    disk_size_gb = var.disksize
    disk_type    = var.disktype
    workload_metadata_config {
      mode = var.mode
    }


    labels = {
      role = var.role
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}