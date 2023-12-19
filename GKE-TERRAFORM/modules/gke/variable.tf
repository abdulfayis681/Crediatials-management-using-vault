variable "projectid" {
  description = "The ID of the project"
  type        = string
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
variable "account_id" {
    description = "account_id"
    type = string  
}
variable "role" {
    description = "role"
    type = string
}
variable "network" {
    description = "value"
    type = string
  
}
variable "subnetwork" {
    description = "value"
    type = string
  
}
