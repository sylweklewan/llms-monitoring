output "prometheus_ui_url" {
  value = "http://${var.target_host}:${var.port_to_access_prometheus}"
}