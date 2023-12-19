variable "projectid" {
  description = "The ID of the project"
  type        = string
}
variable "service" {
    description = "service"
    type = string
}
variable "disable_on_destroy" {
    description = "disable_on_destroy"
    type = bool
  
}
variable "routing_mode" {
    description = "routing_mode"
    type = string
  
}
variable "auto_create_subnetworks" {
    description = "auto_create_subnetworks"
    type = bool
  
}
variable "delete_default_routes_on_create" {
    description = "delete_default_routes_on_create"
    type = bool
}
variable "mtu" {
    description = "mtu"
    type = number
}
variable "ip_cidr_range" {
    description = "ip_cidr_range"
    type = string
  
}
variable "private_ip_google_access" {
    description = "private_ip_google_access"
    type = bool
  
}
# variable "range_name1" {

#     description = "range_name"
#     type = string
  
# }
# variable "range_name2" {

#     description = "range_name"
#     type = string
  
# }
# variable "ip_cidr_range1" {
#     description = "ip_cidr_range"
#     type = string
  
# }
# variable "ip_cidr_range2" {
#     description = "ip_cidr_range"
#     type = string
  
# }
variable "source_subnetwork_ip_ranges_to_nat" {
    description = "source_subnetwork_ip_ranges_to_nat"
    type = string
  
}
variable "nat_ip_allocate_option" {
    description = "nat_ip_allocate_option"
    type = string
  
}
variable "address_type" {
    description = "address_type"
    type = string
  
}
variable "source_ip_ranges_to_nat" {
    description = "source_ip_ranges_to_nat"
    type = string
  
}
variable "network_tier" {
    description = "network_tier"
    type = string
  
}
variable "protocol" {
    description = "protocol"
    type = string
  
}
variable "ports" {
    description = "ports"
    type = number
}
variable "source_ranges" {
    description = "source_ranges"
    type = string
  
}


variable "clustername" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "The region for the GKE cluster"
  type        = string
}

variable "remove_default_node_pool" {
    description = "remove_default_node_pool"
    type = bool
  
}

variable "logging_service" {
    description = "logging_service"
    type = string
  
}

variable "initial_node_count" {
    description = "initial_node_count"
    type = number
}



variable "nodecount" {
  description = "The number of nodes in the GKE cluster"
  type        = number
}

variable "machinetype" {
  description = "The machine type for the GKE nodes"
  type        = string
}

variable "imagetype" {
  description = "The image type for the GKE nodes"
  type        = string
}

variable "disksize" {
  description = "The disk size in GB for the GKE nodes"
  type        = number
}

variable "disktype" {
  description = "The disk type for the GKE nodes"
  type        = string
}
variable "monitoring_service" {
    description = "monitoring.googleapis.com/kubernetes"
    type = string
  
}
variable "networking_mode" {
    description = "networking_mode"
    type = string
  
}
variable "channel" {
    description = "channel"
    type = string
}
variable "cluster_secondary_range_name" {
    description = "cluster_secondary_range_name"
    type = string
  
}
variable "services_secondary_range_name" {
    description = "services_secondary_range_name"
    type = string
  
}
variable "enable_private_nodes" {
    description = "enable_private_nodes"
    type = bool
  
}
variable "enable_private_endpoint" {
    description = "enable_private_endpoint"
    type = bool
  
}
variable "master_ipv4_cidr_block" {
    description = "master_ipv4_cidr_block"
    type = string
  
}
variable "mode" {
    description = "mode"
    type = string
}

variable "role" {
    description = "role"
    type = string
}
variable "account_id" {
    description = "value"
    type = string
  
}
