resource "google_project_service" "compute" {
  project            = var.projectid
  service            = var.service
  disable_on_destroy = var.disable_on_destroy
}

resource "google_project_service" "container" {
  project            = var.projectid
  service            = var.service
  disable_on_destroy = var.disable_on_destroy
}

resource "google_compute_network" "main" {
  name                            = "${var.clustername}-main"
  routing_mode                    = var.routing_mode
  auto_create_subnetworks         = var.auto_create_subnetworks
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create
  project                         = var.projectid

  depends_on = [
    google_project_service.compute,
    google_project_service.container
  ]
}
resource "google_compute_subnetwork" "private" {
  name                     = "${var.clustername}-private"
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.main.self_link
  private_ip_google_access = var.private_ip_google_access
  project                  = var.projectid

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}
resource "google_compute_router" "router" {
  name    = "${var.clustername}-router"
  region  = var.region
  network = google_compute_network.main.id
  project = var.projectid
}
resource "google_compute_router_nat" "nat" {
  name    = "${var.clustername}-nat"
  project = var.projectid
  router  = google_compute_router.router.name
  region  = var.region

  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  nat_ip_allocate_option             = var.nat_ip_allocate_option

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = [var.source_ip_ranges_to_nat]
  }

  nat_ips = [google_compute_address.nat.self_link]
}

resource "google_compute_address" "nat" {
  name         = "${var.clustername}-nat"
  address_type = var.address_type
  network_tier = var.network_tier
  project      = var.projectid
  region       = var.region

  depends_on = [google_project_service.compute]
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.clustername}-allow-ssh"
  project = var.projectid
  network = google_compute_network.main.name

  allow {
    protocol = var.protocol
    ports    = [var.ports]
  }

  source_ranges = [var.source_ranges]
}