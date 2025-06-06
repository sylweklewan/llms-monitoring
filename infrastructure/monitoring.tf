module "monitoring" {
  source          = "../modules/monitoring"
  ssh_private_key = file("${var.private_key_path}")
  target_host  = var.target_host
  ssh_user = var.ssh_user
  ssh_port = var.ssh_port
  port_to_access_prometheus = var.port_to_access_prometheus
}