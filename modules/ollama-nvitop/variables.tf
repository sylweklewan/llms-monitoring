variable "target_host" {
    type = string
    description = "Host where k8s is running"
}

variable "ssh_private_key" {
    type = string
    description = "Private key used to establish ssh connection"
    sensitive = true
}

variable "model_name" {
    type = string
    default = "deepseek-r1:8b"
}

variable "prompt" {
  type        = string
  default     = "Tell me a joke"
  description = "Prompt to send to the model"
}

variable "port_to_access" {
  type = number
  default = 30080
  description = "Port where model should be accessible"
}

variable "fw_port_to_access" {
  type = number
  default = 30080
  description = "Port where model should be accessible"
}

variable "ssh_user" {
  type = string
  default = "ec2-user"
  description = "User used to connect"
}

variable "ssh_port" {
  type = string
  description = "Port to be used for ssh connection"
  default = "22"
}
variable "replicas" {
  type = number
  description = "Amount of ollama with openlit replicas to run"
  default = 1
}

variable "deployment_name" {
  type = string
  description = "Name used to provide for deployment"
  default = "ollama-deployment"
}


variable "model_size" {
  type = string
  default = "8b"
}

variable "resource_limits" {
  type        = map(string)
  description = "model serving container resource limits (e.g., nvidia.com/gpu = 1)"
  default     = {
    "nvidia.com/gpu" = "1"
  }
}
