output "vpc_self_link" {
  description = "The URI of the created resource"
  value       = google_compute_network.main.self_link
}

output "subnet_self_link" {
  description = "The URI of the created resource"
  value       = google_compute_subnetwork.private.self_link
}

output "vpc_name" {
  description = "vpc network name"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "subnet name"
  value       = google_compute_subnetwork.private.name
}