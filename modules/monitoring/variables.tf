variable "target_host" {
    type = string
    description = "Host where minikube is running"
}

variable "ssh_private_key" {
    type = string
    description = "Private key used to establish ssh connection"
    sensitive = true
}

variable "port_to_access_prometheus" {
  type = number
  default = 30090
  description = "Port where model should be accessible"
}

variable "node_port_to_access_prometheus" {
  type = number
  default = 30090
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