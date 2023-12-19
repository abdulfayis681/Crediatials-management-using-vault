module "vpc" {
    source = "./modules/vpc"
    region = var.region
    clustername = var.clustername
    source_ip_ranges_to_nat = var.source_ip_ranges_to_nat

  projectid           = var.projectid
  service            = var.service
  disable_on_destroy = var.disable_on_destroy
  routing_mode                    = var.routing_mode
  auto_create_subnetworks         = var.auto_create_subnetworks
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create
  ip_cidr_range            = var.ip_cidr_range
  private_ip_google_access = var.private_ip_google_access

  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  address_type = var.address_type
  network_tier = var.network_tier


  protocol = var.protocol
  ports    = var.ports

  source_ranges = var.source_ranges

}
module "gke" {
    source = "./modules/gke"
    network      = module.vpc.vpc_self_link
    subnetwork   = module.vpc.subnet_self_link
    machinetype = var.machinetype
    disktype = var.disktype
    region = var.region
    nodecount = var.nodecount

    clustername             = var.clustername
    disksize                   = var.disksize
    projectid                 = var.projectid
    remove_default_node_pool = var.remove_default_node_pool
    initial_node_count       = var.initial_node_count
    logging_service          = var.logging_service
    monitoring_service       = var.monitoring_service
    networking_mode          = var.networking_mode
    channel = var.channel

    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name

    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    mode = var.mode
    account_id = var.account_id
    imagetype   = var.imagetype
    
 



    role = var.role

  depends_on = [ module.vpc ]
}


