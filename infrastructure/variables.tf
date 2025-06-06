variable "target_host" {
    type = string
    description = "public_ip of machine host k8s"
}

variable "private_key_path" {
  type = string
  description = "file with public key"
  default = "~/.keys/pub.pem"
}

variable "kubernetes_api_config" {
  type = string
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


variable "port_to_access_prometheus" {
  type = string
  description = "Port to use to access prometheus"
  default = "30090"
}