locals {
  model_sizes = {
      "0" = "8b"
      "1" = "32b"
  }

  ports_to_access = {
      "0" = 30070
      "1" = 30080    
  }

  fw_ports_to_access = {
      "0" = 10401
      "1" = 10434
  }

  model_names = {
    "0" = "qwen3:${local.model_sizes[0]}"
    "1" = "qwen3:${local.model_sizes[1]}"
  }

  deployment_names = {
    "0" = "ollama-deployment-${local.model_sizes[0]}"
    "1" = "ollama-deployment-${local.model_sizes[1]}"
  }
}

module "ollama_with_nvitop_gpu_server" {
  count = 2
  source          = "../modules/ollama-with-model"
  ssh_private_key = file("${var.private_key_path}")
  target_host  = var.target_host
  ssh_user = var.ssh_user
  ssh_port = var.ssh_port
  replicas = 1
  model_name = local.model_names[tostring(count.index)]
  deployment_name = local.deployment_names[tostring(count.index)]
  model_size = local.model_sizes[tostring(count.index)]
  port_to_access = local.ports_to_access[tostring(count.index)]
  fw_port_to_access = local.fw_ports_to_access[tostring(count.index)]
  resource_limits = {"nvidia.com/gpu" = "1"}
  #resource_limits = {"nvidia.com/mig-1g.20gb": "1"}  
}
