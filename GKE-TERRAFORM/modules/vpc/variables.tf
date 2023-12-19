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
    type = string
}
variable "source_ranges" {
    description = "source_ranges"
    type = string
  
}
variable "region" {
    description = "region"
    type = string
}
variable "clustername" {
    description = "value"
    type = string
  
}